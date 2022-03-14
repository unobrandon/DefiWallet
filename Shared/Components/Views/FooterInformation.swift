//
//  FooterInformation.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/27/22.
//

import SwiftUI

struct FooterInformation: View {

    @State var middleText: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            HStack {
                Image("AppIcon-Dev")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27, height: 18, alignment: .center)

                Text("DefiWallet")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .offset(x: -2)
            }

            if self.middleText != "" {
                Text(self.middleText)
                    .font(.caption)
                    .fontWeight(.none)
                    .foregroundColor(.secondary)
            }

            Text("version: " + Constants.projectVersion)
                .font(.caption)
                .fontWeight(.none)
                .italic()
                .foregroundColor(.secondary)
        }
    }

}
