//
//  TextViewInteractiveBordered.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/4/22.
//

import SwiftUI
import SwiftUIX

struct TextViewInteractiveBordered: View {

    @Binding var text: String
    @Binding var hasError: Bool

    @State private var hasText: Bool = false
    @State private var isFocused: Bool = false
    @State private var exceededLimit: Bool = false

    private let placeholder: String
    private let errorMessage: String
    private var textLimit: Int
    private var maxHeight: Int
    private let onCommit: () -> Void

    init(text: Binding<String>, hasError: Binding<Bool>, placeholder: String, errorMessage: String, textLimit: Int?, maxHeight: Int?, onCommit: @escaping () -> Void) {
        self._text = text
        self._hasError = hasError
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self.textLimit = textLimit ?? 0
        self.maxHeight = maxHeight ?? 120
        self.onCommit = onCommit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextView("", text: $text, onEditingChanged: { isFocused in
                self.isFocused = isFocused
            }, onCommit: { self.onCommit() })
            #if os(iOS)
            .returnKeyType(.join)
            #endif
            .padding(.horizontal)
            .offset(y: hasText ? 12.5 : 0)
            .background(
                HStack(alignment: .center, spacing: 0) {
                    Text(placeholder)
                        .scaleEffect(hasText ? 0.8 : 1)
                        .lineLimit(hasText ? 1 : 3)
                        .foregroundColor(hasText ? (exceededLimit || hasError ? .red : (isFocused ? Color("AccentColor") : .secondary)) : .secondary)

                    if hasText && textLimit != 0 {
                        Text(hasError ? errorMessage : "\(text.count)" + "/" + "\(textLimit)")
                            .font(.caption)
                            .foregroundColor(exceededLimit || hasError ? .red : .secondary)
                            .offset(x: -5)
                    }
                    Spacer()
                }
                .padding(.leading, 17.5)
                .offset(x: (hasText ? -35 : 0), y: hasText ? -10 : 0), alignment: .topLeading)
            .onChange(of: text) { text in

                if text.count >= textLimit, textLimit != 0 {
                    exceededLimit = true

                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                } else {
                    exceededLimit = false
                }

                guard text.isEmpty, hasText else {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 0)) {
                        hasText = true
                    }

                    return
                }

                withAnimation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 0)) {
                    hasText = false
                }
            }
        }
        .frame(minHeight: CGFloat(Double(maxHeight) / 1.75), maxHeight: CGFloat(maxHeight))
        .padding(.vertical, 12.5)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(exceededLimit || hasError ? Color("alertRed") : DefaultTemplate.borderColor, lineWidth: 2)
                    .shadow(color: isFocused ? .black.opacity(0.1) : .clear, radius: 5, x: 0, y: 1))
        .onAppear {
            if !text.isEmpty {
                hasText = true
            }

            if text.count >= textLimit, textLimit != 0 {
                exceededLimit = true
            } else {
                exceededLimit = false
            }
        }
    }
}
