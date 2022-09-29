//
//  CustomLineChart.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/19/22.
//

import SwiftUI
import SwiftUIX

struct CustomLineChart: View {

    var data: [Double]
    var timeline: [Int]?
    var profit: Bool = false

    @Binding var perspective: String
    @State var currentPlotValue: Double = 0.0
    @State var currentPlot = ""
    @State var offset: CGSize = .zero
    @State var showPlot = false
    @State var translation: CGFloat = 0
    @State var graphProgress: CGFloat = 0

    @GestureState var isDrag: Bool = false

    var body: some View {
        GeometryReader { proxy in

            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)

            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0

            let points = data.enumerated().compactMap { item -> CGPoint in
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                let chartOffset = timeline != nil ? (height + 15) : height
                let pathHeight = progress * chartOffset
                let pathWidth = width * CGFloat(item.offset)

//                guard graphProgress != 0 else {
//                    return CGPoint(x: pathWidth, y: 125.0)
//                }

                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }

            ZStack {
                AnimatedGraphPath(progress: graphProgress, points: points)
                    .fill(LinearGradient(colors: [
                        profit ? Color.green : Color.red,
                        profit ? Color.green : Color.red
                        ], startPoint: .leading, endPoint: .trailing))

                // Path Background Coloring...
                fillBG()
                    .clipShape(Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLines(points)
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                        })
                    .opacity(graphProgress)
            }
            .overlay(
                // Drag indicator...
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.sectionHeader_bold)

                            MovingNumbersView(number: currentPlotValue,
                                              numberOfDecimalPlaces: 2,
                                              fixedWidth: nil,
                                              theme: DefaultTemplate.sectionHeader_bold,
                                              showComma: true) { str in
                                Text(str).fontTemplate(DefaultTemplate.sectionHeader_bold)
                            }
                        }.mask(AppGradients.movingNumbersMask)

                        if !currentPlot.isEmpty {
                            Text(currentPlot)
                                .fontTemplate(DefaultTemplate.caption_micro_Mono_secondary)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(BlurEffectView(style: .systemUltraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 5)))
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                    .offset(x: translation < 35 ? (35 - translation) + 10 : 0)
                    .offset(x: translation > (proxy.size.width - 50) ? -50 : 0)

                    BlurEffectView(style: .systemUltraThinMaterial)
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                        .overlay(Circle().fill(Color("AccentColor")).frame(width: 12, height: 12))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .frame(width: 160, height: 85)
                .offset(offset)
                .opacity(showPlot ? 1 : 0)
                , alignment: .bottomLeading)
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
//                guard graphProgress == 0 else { return }

                withAnimation { showPlot = true }

                let translation = value.location.x
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)

                guard data.count >= index + 1 else { return }

                currentPlotValue = data[index]
                if let time = timeline?[index] {
                    currentPlot = "\(Date(timeIntervalSince1970: Double(time)).shortDateFormate())"
                }
                self.translation = translation

                // removing half width...
                offset = CGSize(width: points[index].x - 80, height: points[index].y - height + 10)
            }).onEnded({ _ in
                withAnimation { showPlot = false }
            }).updating($isDrag, body: { _, out, _ in
                out = true
            }))
            .onLongPressGesture(minimumDuration: 15.0, pressing: { pressing in
                showPlot = !pressing

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            }, perform: {  })
            .background(
                VStack(alignment: .trailing, spacing: 5) {
                    if data.count >= 4 {
                        VStack(alignment: .trailing, spacing: height / 4) {
                            ForEach(data.sorted(by: >).subArray(length: 4), id: \.self) { data in
                                VStack(alignment: .trailing, spacing: 2.5) {
                                    Text(data.convertToCurrency())
                                        .fontTemplate(DefaultTemplate.caption_micro_Mono_secondary)

                                    Rectangle()
                                        .frame(height: 1)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(DefaultTemplate.borderColor)
                                }
                            }
                        }
                    }

                    Spacer()
                    if let timeline = timeline {
                        Divider().offset(y: 10)

                        HStack() {
                            ForEach(timeline.sorted(by: >).subArray(length: 4), id: \.self) { date in
                                Text(Date(timeIntervalSince1970: Double(date)).chartDateFormate(perspective: perspective))
                                    .fontTemplate(DefaultTemplate.caption_micro_Mono_secondary)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .frame(maxHeight: 35)
                            }.frame(maxWidth: .infinity, alignment: .bottomLeading)
                        }
                        .offset(y: -10)
                    }
                }
            )
        }
        .onChange(of: isDrag) { _ in
            if !isDrag { showPlot = false }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { _ in
            // MARK: Re-animating when ever plot data updates
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
    }

    @ViewBuilder func fillBG() -> some View {
        let color = profit ? Color.green : Color.red
        LinearGradient(colors: [
            color.opacity(0.3),
            color.opacity(0.2),
            color.opacity(0.15),
            color.opacity(0.00)], startPoint: .top, endPoint: .bottom)
    }

}

// MARK: Animated Path
struct AnimatedGraphPath: Shape {

    var progress: CGFloat
    var points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 1.85, lineCap: .round, lineJoin: .round))
    }

}
