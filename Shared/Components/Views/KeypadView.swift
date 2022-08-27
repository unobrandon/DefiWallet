//
//  KeypadView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/19/22.
//

import SwiftUI

struct KeypadView: View {

    @Binding var value: String

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: SwiftUI.GridItem(.flexible(), spacing: 5), count: 3), spacing: 5) {
                ForEach(1...9,id: \.self) { value in
                    KeypadButton(title: "\(value)", value: $value)
                }

                KeypadButton(title: ".", value: $value)

                KeypadButton(title: "0", value: $value)

                KeypadButton(title: "delete.fill", value: $value)
            }
            .padding(.horizontal)
        }
    }

}

struct KeypadButton : View {

    var title : String
    @Binding var value : String

    var body: some View {
        Button(action: setStringValue, label: {
            VStack {
                if title.count > 1 {
                    Image(systemName: "delete.left")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                } else {
                    Text(title)
                        .font(.title)
                        .foregroundColor(.primary)
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
        })
        .buttonStyle(KeyboardInteractiveStyle(cornerRadius: 10))
        .contentShape(Rectangle())
    }

    func setStringValue() {
        withAnimation {
            if title.count > 1 {
                if !value.isEmpty {
                    value.removeLast()

                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                } else {
                    #if os(iOS)
                        HapticFeedback.errorHapticFeedback()
                    #endif
                }
            } else if title == "." {
                if value.isEmpty {
                    value = "0."

                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                } else if !value.contains(".") {
                    value.append(title)

                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                } else {
                    #if os(iOS)
                        HapticFeedback.errorHapticFeedback()
                    #endif
                }
            } else if !value.contains("."), Double(value) ?? 1 == 0 {
                if title != "0" {
                    value.removeAll()
                    value.append(title)

                    print("can not add zero to \(title), so removed all")
                    #if os(iOS)
                        HapticFeedback.lightHapticFeedback()
                    #endif
                } else {
                    print("can not add zero to zero")
                    #if os(iOS)
                        HapticFeedback.errorHapticFeedback()
                    #endif
                }
            } else {
                value.append(title)

                #if os(iOS)
                    HapticFeedback.lightHapticFeedback()
                #endif
            }

            print("the keypad value is: \(value)")
        }
    }
}
