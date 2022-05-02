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
    var profit: Bool = false

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
                let pathHeight = progress * (height - 25)
                let pathWidth = width * CGFloat(item.offset)

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
                // Drag Indicator...
                VStack(spacing: 25) {
                    Text(currentPlot)
                        .fontTemplate(DefaultTemplate.captionPrimary_semibold)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(BlurEffectView(style: .systemUltraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 5)))
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)

                    BlurEffectView(style: .systemUltraThinMaterial)
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                        .overlay(Circle().fill(Color("AccentColor")).frame(width: 12, height: 12))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .frame(width: 80, height: 55)
                .offset(offset)
                .opacity(showPlot ? 1 : 0)
                , alignment: .bottomLeading)
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation { showPlot = true }

                let translation = value.location.x
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)

                currentPlot = data[index].convertToCurrency()
                self.translation = translation

                // removing half width...
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ _ in
                withAnimation { showPlot = false }
            }).updating($isDrag, body: { _, out, _ in
                out = true
            }))
        }
        .background(
            VStack(alignment: .trailing) {
                if let max = data.max() {
                    Text(max.convertToCurrency())
                        .fontTemplate(DefaultTemplate.caption_semibold)
                }

                Spacer()
                if let min = data.min() {
                    Text(min.convertToCurrency())
                        .fontTemplate(DefaultTemplate.caption_semibold)
                        .offset(y: 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        )
        .padding(.horizontal, 10)
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

    @ViewBuilder
    func fillBG() -> some View {
        let color = profit ? Color.green : Color.red
        LinearGradient(colors: [
            color.opacity(0.3),
            color.opacity(0.2),
            color.opacity(0.1)] + Array(repeating: color.opacity(0.1), count: 4) + Array(repeating: Color.clear, count: 2), startPoint: .top, endPoint: .bottom)
    }

}

// MARK: Animated Path
struct AnimatedGraphPath: Shape {

    var progress: CGFloat
    var points: [CGPoint]

    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }

}
