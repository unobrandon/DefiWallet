//
//  ExampleComponents.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/28/22.
//

import SwiftUI

struct ExampleComponents: View {
    var body: some View {
        LoadingIndicator(size: 25)

        RoundedButton("Show Noti", style: .secondary, systemImage: "paperplane.fill", action: {
            showNotiHUD(image: "wifi", color: .blue, title: "Connected", subtitle: "")
        })

        TextFieldSingleBordered(text: "", placeholder: "username", systemImage: "person.crop.circle", textLimit: 20, onEditingChanged: { text in
            print("text changed: \(text)")
        }, onCommit: {
            print("returned username ehh")
        })

        ListSection(title: "Hello Crypto", style: .shadow) {
            TextFieldSingleList(text: "", placeholder: "enter 12 or 24 seed phrase here", systemImage: "list.bullet.rectangle", textLimit: nil, isLast: true, onEditingChanged: { text in
                print(text)
            }, onCommit: {
                print("commit ed")
            })
        }

        ListSection(title: "Hello World", style: .shadow) {
            ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: false, style: .shadow, action: {
                print("Come")
            })

            ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: true, style: .shadow, action: {
                print("Come")
            })
        }

        ListSection(title: "Hello World", style: .border) {
            ListButtonStandard(title: "add up man", systemImage: "safari", isLast: false, style: .border, action: {
                print("Come")
                ethAddressLength += 5.483
            })

            ListButtonStandard(title: "sub down man", systemImage: "safari", isLast: true, style: .border, action: {
                print("Come")
                ethAddressLength -= 8.624

            })
        }
    }
}

struct ExampleComponents_Previews: PreviewProvider {
    static var previews: some View {
        ExampleComponents()
    }
}
