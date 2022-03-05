//
//  TextFieldSingle.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/27/22.
//

import SwiftUI

struct TextFieldSingleBordered: View {

    @State var text: String = ""

    @State private var hasText: Bool = false
    @State private var exceededLimit: Bool = false
    @State private var isSecure: Bool = false
    @State private var isTextVisible: Bool = false
    @FocusState private var focusedField: Bool

    private let placeholder: String
    private var textLimit: Int = 0
    private var systemImage: String = ""
    private var localImage: String = ""
    private let onEditingChanged: (String) -> Void
    private let onCommit: () -> Void

    init(text: String, placeholder: String, textLimit: Int?, onEditingChanged: @escaping (String) -> Void = { _ in }, onCommit: @escaping () -> Void) {
        self.text = text
        self.placeholder = placeholder
        self.textLimit = textLimit ?? 0
        self.onCommit = onCommit
        self.onEditingChanged = onEditingChanged
    }

    init(text: String, placeholder: String, systemImage: String, textLimit: Int?, onEditingChanged: @escaping (String) -> Void = { _ in }, onCommit: @escaping () -> Void) {
        self.text = text
        self.placeholder = placeholder
        self.systemImage = systemImage
        self.textLimit = textLimit ?? 0
        self.onCommit = onCommit
        self.onEditingChanged = onEditingChanged
    }

    init(text: String, placeholder: String, localImage: String, textLimit: Int?, onEditingChanged: @escaping (String) -> Void = { _ in }, onCommit: @escaping () -> Void) {
        self.text = text
        self.placeholder = placeholder
        self.localImage = localImage
        self.textLimit = textLimit ?? 0
        self.onCommit = onCommit
        self.onEditingChanged = onEditingChanged
    }

    init(text: String, placeholder: String, textLimit: Int?, isSecure: Bool, onEditingChanged: @escaping (String) -> Void = { _ in }, onCommit: @escaping () -> Void) {
        self.text = text
        self.placeholder = placeholder
        self.textLimit = textLimit ?? 0
        self.isSecure = isSecure
        self.onCommit = onCommit
        self.onEditingChanged = onEditingChanged
    }

    init(placeholder: String, onEditingChanged: @escaping (String) -> Void = { _ in }, onCommit: @escaping () -> Void) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 2.5) {
                if !systemImage.isEmpty {
                    Image(systemName: systemImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(focusedField || hasText ? .primary : .secondary)
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding(.trailing, 5)
                        .offset(y: hasText ? 5 : 0)
                } else if !localImage.isEmpty {
                    Image(localImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26, alignment: .center)
                        .padding(.trailing, 5)
                        .offset(y: hasText ? 5 : 0)
                }

                if isSecure && !isTextVisible {
                    SecureField("", text: $text)
                        .focused($focusedField)
                        .autocapitalization(.none)
                        .offset(y: hasText ? 4 : 0)
                        .onSubmit { self.onCommit() }
                } else {
                    TextField("", text: $text)
                        .focused($focusedField)
                        .autocapitalization(isSecure ? .none : .words)
                        .offset(y: hasText ? 5 : 0)
                        .onSubmit { self.onCommit() }
                }

                if isSecure {
                    Button {
                        isTextVisible.toggle()
                        #if os(iOS)
                            HapticFeedback.lightHapticFeedback()
                        #endif
                    } label: {
                        Image(systemName: isTextVisible ? "eye" : "eye.slash")
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 5)
                }
            }
            .padding(.top, hasText ? 7.5 : 0)
            .background(
                HStack(alignment: .center, spacing: 0) {
                    Text(placeholder)
                        .scaleEffect(hasText ? 0.8 : 1)
                        .foregroundColor(hasText ? (exceededLimit ? .red : (focusedField ? Color("AccentColor") : .secondary)) : .secondary)

                    Text("\(text.count)" + "/" + "\(textLimit)")
                        .font(.caption)
                        .foregroundColor(exceededLimit ? .red : .secondary)
                        .offset(x: -5)
                        .opacity(hasText && textLimit != 0 ? 1 : 0)
                    Spacer()
                }.offset(x: (hasText ? -15 : !systemImage.isEmpty ? 30 : !localImage.isEmpty ? 35 : 0), y: hasText ? -15 : 0), alignment: .leading)
            .padding(.horizontal)
        }
        .padding(.vertical, 12.5)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(exceededLimit ? Color("alertRed") : DefaultTemplate.borderColor, lineWidth: 2)
                    .shadow(color: focusedField ? .black.opacity(0.1) : .clear, radius: 5, x: 0, y: 1))
        .padding(.horizontal)
        .onChange(of: text) { text in
            self.onEditingChanged(text)

            if text.count >= textLimit, textLimit != 0 {
                exceededLimit = true
                HapticFeedback.lightHapticFeedback()
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
