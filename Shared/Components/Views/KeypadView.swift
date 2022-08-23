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
                }
            } else {
                value.append(title)
            }

            print("the keypad value is: \(value)")
        }
    }
}
