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

    init(_ text: String, isCaption: Bool? = nil, lineLimit: Int? = 0) {
        self.text = text
        self.isCaption = isCaption ?? true
        self.lineLimit = lineLimit ?? 3
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .fontTemplate(isCaption ? DefaultTemplate.caption : DefaultTemplate.body)
                .multilineTextAlignment(.leading)
                .lineLimit(expanded ? nil : 3)
                .background(
                    Text(text).lineLimit(3)
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
                .padding(.bottom, truncated ? 2.5 : 5)

            if truncated { toggleButton.padding(.bottom, 5) }
        }
    }

    var toggleButton: some View {
        Button(action: {
            withAnimation(.easeOut) {
                self.expanded.toggle()
            }
        }, label: {
            Text(self.expanded ? "Read less..." : "Read more...").font(.caption)
        })
    }

}
