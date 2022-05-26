//
//  MovingNumbersView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, *)
public struct MovingNumbersView<Element: View>: View {

    public typealias ElementBuilder = (String) -> Element

    /// The number to show.
    public let number: Double

    /// Number of decimal places to show. If 0, will show integers (i.e. no dot or decimal)
    ///
    /// Note that we round up  before showing.
    public let numberOfDecimalPlaces: Int

    /// Space between each digit in the 10-digit vertical stack
    public var verticalDigitSpacing: CGFloat = 0

    /// Animation duration for the vertical digit stack to move up and down
    public var animationDuration: Double = 0.25

    /// Should show comma  or now. Used in eth addresses
    public var showComma: Bool?

    /// Give a fixed width to the view. This would give better transition effect as digits are not clipped off.
    public var fixedWidth: CGFloat?

    /// Function to build digit, comma, and dot components
    public let elementBuilder: ElementBuilder

    private var digitStackAnimation: Animation {
        Animation
            .easeOut(duration: animationDuration)
    }

    private var elementTransition: AnyTransition {
        AnyTransition.move(edge: .leading)
    }

    public init(number: Double,
                numberOfDecimalPlaces: Int,
                fixedWidth: CGFloat? = nil,
                verticalDigitSpacing: CGFloat = 0,
                animationDuration: Double = 0.25,
                showComma: Bool?,
                elementBuilder: @escaping ElementBuilder) {
        self.number = number
        self.numberOfDecimalPlaces = numberOfDecimalPlaces
        self.fixedWidth = fixedWidth
        self.verticalDigitSpacing = verticalDigitSpacing
        self.animationDuration = animationDuration
        self.showComma = showComma ?? true
        self.elementBuilder = elementBuilder
    }

    private func movingNumbersView() -> some View {
        let isNegative = self.number < 0

        // Deal with positive first
        let number = abs(self.number)

        // Rounding
        let roundedNumber = round(number, numPlaces: numberOfDecimalPlaces)

        // Split
        let (whole, fraction) = modf(roundedNumber)

        // Example: 123.45

        // Whole - 123
        let wholeElements = getWholeVisualElements(whole: Int(whole))
        // [3,2,1]

        let negativeElement: [VisualElementType] = isNegative ? [.minus] : []
        let allElements: [VisualElementType]

        // If decimal
        if numberOfDecimalPlaces > 0 {
            // [4, 5]
            let fractionElements = getDecimalVisualElements(fraction: fraction, numberOfDecimalPlaces: numberOfDecimalPlaces)
            allElements = negativeElement + wholeElements.reversed() + [.dot] + fractionElements
        } else {
            allElements = negativeElement + wholeElements.reversed()
        }

        // All elements are by default vertically centered
        let finalResultView = HStack(alignment: .center, spacing: 0) {
            ForEach(allElements) { (element) in
                self.viewFromElement(element)
                    .transition(self.elementTransition)
                    .animation(self.digitStackAnimation)
            }
        }
        .frame(width: fixedWidth, alignment: .leading)

        // For debugging
        // print("All:", allElements)
        // print("Ids:", allElements.map { $0.id })

        // PROBLEM: Final result view takes a big size
        // (i.e. 10-digit stack height, no. of digits width)
        // We want the final layout of the view to be just like
        // its appearance, i.e. A couple of Texts in HStack.
        //
        // HACK: Make a stand-in estimated view for layout.
        // So this allows us to treat this view almost like Text

        // Would `PreferenceKey` works?
        let estimatedView = MovingNumbersViewEstimatedSize(
            allElements: allElements,
            elementBuilder: elementBuilder)
            .frame(width: fixedWidth, alignment: .leading)

        return estimatedView
            .opacity(0.001)
            .overlay(finalResultView, alignment: .leading)
            .mask(Rectangle())
    }

    public var body: some View {
        movingNumbersView()
    }
}

@available(iOS 13.0, OSX 10.15, *)
private extension MovingNumbersView {
    enum VisualElementType: CustomDebugStringConvertible, Identifiable {
        case digit(Int, position: Int)
        case comma(position: Int)
        case dot
        case decimalDigit(Int, position: Int)
        case minus

        var id: Int {
            // - Digit has id as a multiple of 10s,
            // - Decimal place has a negative multiple of 10s
            // - 0 is reserved for dot.
            // - 1 is reserved for minus
            // - comma is the id of previous digit + 5.
            //
            // I.e. -1,234.56 -> [1(minus), 40, 35, 30, 20, 10, 0(dot), -10, -20]
            switch self {
            case let .digit(_, position):
                assert(position > 0)
                return 10 * position
            case let .comma(position):
                assert(position > 0)
                // Give comma the id between two digits.
                return 10 * position + 5
            case let .decimalDigit(_, position):
                assert(position > 0)
                return -10 * position
            case .dot:
                // Reserve 0 for dot
                return 0
            case .minus:
                // Reserve of "-"
                return 1
            }
        }
        var debugDescription: String {
            switch self {
            case .dot: return "."
            case let .comma(ppp): return ",(pos:\(ppp))"
            case let .digit(val, ppp): return "\(val)(pos:\(ppp))"
            case let .decimalDigit(val, ppp): return "\(val)(pos:\(ppp))"
            case .minus: return "-"
            }
        }
    }

    func viewFromElement(_ element: VisualElementType) -> some View {
        switch element {
        case let .digit(value, _):
            return AnyView(self.buildDigitStack(showingDigit: value))
        case let .decimalDigit(value, _):
            return AnyView(self.buildDigitStack(showingDigit: value))
        case .dot:
            return AnyView(self.buildDot())
        case .comma:
            return AnyView(self.buildComma())
        case .minus:
            return AnyView(self.buildMinus())
        }
    }

    func buildDigitStack(showingDigit digit: Int) -> some View {
        let digit = CGFloat(digit)
        let dss = TenDigitStack(
            spacing: verticalDigitSpacing,
            elementBuilder: elementBuilder)
            .drawingGroup()
            .modifier(VerticalShift(
                diffNumber: digit,
                digitSpacing: verticalDigitSpacing))
        return dss
    }

    func buildComma() -> some View {
        elementBuilder((showComma ?? true) ? "," : "")
    }

    func buildDot() -> some View {
        elementBuilder(".")
    }

    func buildMinus() -> some View {
        elementBuilder("-")
    }

    /// A vertical stack of 9 -> 0.
    struct TenDigitStack: View {
        var spacing: CGFloat?
        let elementBuilder: ElementBuilder
        var body: some View {
            VStack(alignment: .center, spacing: spacing) {
                ForEach((0...9).reversed(), id: \.self) { iDigit in
                    self.elementBuilder("\(iDigit)")
                }
            }
            .padding(.bottom, spacing)
            // Padding so the bottom most digit (0)
            // has the padding like others.
        }
    }

    /// Make the digit stack moves up and down if the diffNumber changes.
    struct VerticalShift: GeometryEffect {
        var diffNumber: CGFloat // 0 to 9 only
        let digitSpacing: CGFloat

        var animatableData: CGFloat {
            get { diffNumber }
            set { diffNumber = newValue }
        }

        func effectValue(size: CGSize) -> ProjectionTransform {
            // The 0.5 is to center right at a single number.
            // i.e. for 10 digits the center is between some two numbers.
            let translationY = -size.height/2 + (size.height / 10) * (diffNumber + 0.5) + digitSpacing/2
            return .init(.init(
                translationX: 0,
                y: translationY
            ))
        }
    }

    /// Get visual elements for the whole number part
    /// i.e. 1234 -> 1,234
    func getWholeVisualElements(whole: Int) -> [VisualElementType] {
        let wholeDigits = getAllDigitsInAscendingSignificance(number: whole)
        var wholeElements: [VisualElementType] = []

        for (iii, digit) in wholeDigits.enumerated() {
            if iii != 0 && iii % 3 == 0 {
                wholeElements.append(.comma(position: iii+1))
            }
            wholeElements.append(.digit(digit, position: iii+1))
        }
        return wholeElements
    }

    /// Get visual elements for the decimal parts
    func getDecimalVisualElements(fraction: Double, numberOfDecimalPlaces: Int) -> [VisualElementType] {
        var fractionElements: [VisualElementType] = []
        let decimals = Int(round(fraction * pow(10.0, Double(numberOfDecimalPlaces))))
        // [5, 4]
        var fractionDigits = getAllDigitsInAscendingSignificance(number: decimals)
        // Prepend with 0s that're gone when fraction is 0.
        let numberOfAdditionalZeros = numberOfDecimalPlaces - fractionDigits.count
        if numberOfAdditionalZeros > 0 {
            fractionDigits.append(contentsOf: repeatElement(0, count: numberOfAdditionalZeros))
        }

        // Work from least significant: [4, 5]
        for (iii, digit) in fractionDigits.reversed().enumerated() {
            fractionElements.append(.decimalDigit(digit, position: iii+1))
        }

        return fractionElements
    }
}

@available(iOS 13.0, OSX 10.15, *)
private extension MovingNumbersView {
    /// View that has roughly  the same size of the original MovingNumbersView. This will be the actual size which the actual content is overlaid on.
    struct MovingNumbersViewEstimatedSize: View {

        let allElements: [VisualElementType]
        let elementBuilder: ElementBuilder

        func buildDummyElement(_ originalElement: VisualElementType) -> some View {
            switch originalElement {
            case .minus:
                return self.elementBuilder("-")
            case .dot:
                return self.elementBuilder(".")
            case .comma:
                return self.elementBuilder(",")
            case .digit, .decimalDigit:
                // This column takes the widest one.
                // We estimate it to be 9.
                return self.elementBuilder("9")
            }
        }

        var body: some View {
            HStack(spacing: 0) {
                ForEach(self.allElements) { ell in
                    self.buildDummyElement(ell)
                }
            }
        }
    }
}

/// Given an **non-negative** integer, extract all digits starting *from least to most significant position*, i.e. 123 -> [3,2,1]
///
/// Note that if `number` is negative, we use `abs(number)`.
private func getAllDigitsInAscendingSignificance(number: Int) -> [Int] {
    if number == 0 {
        return [0]
    }
    var rest = abs(number)
    var digits: [Int] = []
    while rest >= 10 {
        let quotient = rest / 10
        let ddd = rest - (quotient * 10)
        digits.append(ddd)
        rest = quotient
    }
    if rest != 0 {
        digits.append(rest)
    }
    return digits
}

private func round(_ number: Double, numPlaces: Int) -> Double {
    let power = pow(10.0, Double(numPlaces))
    return round(number * power)/power
}
