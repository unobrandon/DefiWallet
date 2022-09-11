//
//  ViewMoreText.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/11/22.
//

import SwiftUI

struct ViewMoreText: View {

    @State private var expanded: Bool = false
    @State private var truncated: Bool = false

    private let text: String
    private var isCaption: Bool = true
    private var lineLimit: Int? = 3

    init(_ text: String, isCaption: Bool? = nil, lineLimit: Int? = 3) {
        self.text = text
        self.isCaption = isCaption ?? true
        self.lineLimit = lineLimit ?? 3
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button(action: {
                withAnimation(.easeOut(duration: 0.15)) {
                    self.expanded.toggle()
                }

                #if os(iOS)
                    HapticFeedback.lightHapticFeedback()
                #endif
            }, label: {
                Text(text)
                    .fontTemplate(isCaption ? DefaultTemplate.caption : DefaultTemplate.body)
                    .multilineTextAlignment(.leading)
                    .lineLimit(expanded ? nil : lineLimit)
                    .background(
                        Text(text).lineLimit(lineLimit)
                            .background(GeometryReader { displayedGeometry in
                                ZStack {
                                    Text(text)
                                        .background(GeometryReader { fullGeometry in
                                            Color.clear.onAppear {
                                                self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                            }
                                        })
                                }
                                .frame(height: .greatestFiniteMagnitude)
                            })
                            .hidden() // Hide the background
                    )
                    .padding(.top, 5)
            })
            .disabled(!truncated)
            .buttonStyle(ClickInteractiveStyle(0.999))

            if truncated { toggleButton }
        }
    }

    var toggleButton: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.15)) {
                self.expanded.toggle()
            }

            #if os(iOS)
                HapticFeedback.lightHapticFeedback()
            #endif
        }, label: {
            Text(self.expanded ? "Read less..." : "Read more...")
                .fontTemplate(DefaultTemplate.caption_accent_regular)
        })
        .buttonStyle(ClickInteractiveStyle(0.98))
    }

}
