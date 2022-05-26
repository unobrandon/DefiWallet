//
//  TermsView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/27/22.
//

import SwiftUI
import Stinsen

struct TermsView: View {

    @State var navTitle: String

    init(navTitle: String) {
        self.navTitle = navTitle
    }

    var body: some View {
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ListSection(title: "", style: .border, {
                        Text("Text downloaded from the webs.")
                            .fontTemplate(DefaultTemplate.subheadingLight)
                            .padding()
                    })

                    Spacer()
                    FooterInformation(middleText: "last updated: Feb 27, 2022")
                        .padding(.top, 50)
                        .padding(.bottom, 25)
                }.padding(.top, 110)
            }.navigationBarTitle(self.navTitle, displayMode: .automatic)
            .navigationBarItems(trailing:
                                Menu {
                                    if self.navTitle != "EULA Agreement" {
                                        Button(action: {
                                            self.navTitle = "EULA Agreement"
                                        }, label: {
                                            Label("EULA Agreement", systemImage: "doc.text")
                                        })
                                    }

                                    if self.navTitle != "Privacy Policy" {
                                        Button(action: {
                                            self.navTitle = "Privacy Policy"
                                        }, label: {
                                            Label("Privacy Policy", systemImage: "doc.text")
                                        })
                                    }

                                    if self.navTitle != "Terms of Service" {
                                        Button(action: {
                                            self.navTitle = "Terms of Service"
                                        }, label: {
                                            Label("Terms of Service", systemImage: "doc.text")
                                        })
                                    }
                                } label: {
                                    Image(systemName: "doc.text")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color("AccentColor"))
                                        .frame(width: 22, height: 22)
                                }.buttonStyle(ClickInteractiveStyle(0.99))
            )
        }
    }

}
