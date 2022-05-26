//
//  EnsAvatarView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/7/22.
//

import SwiftUI

struct EnsAvatarView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    @ObservedObject private var store: UnauthenticatedServices

    @State var disablePrimaryAction: Bool = true
    @State var showImagePicker: Bool = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var avatarProgress: Double = 0.0

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                OnboardingHeaderView(imageName: "person.circle",
                                     title: "Profile avatar",
                                     subtitle: "Upload an avatar that will be linked to your universal ENS username")

                Spacer()
                ZStack(alignment: .center) {
                    Button(action: {
                        #if os(iOS)
                            withAnimation { showImagePicker.toggle() }

                            HapticFeedback.lightHapticFeedback()
                        #endif
                    }, label: {
                        ZStack(alignment: .center) {
                            Circle()
                                .trim(from: 0, to: avatarProgress)
                                .stroke(Color.primary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                                .foregroundColor(Color("AccentColor"))
                                .opacity(avatarProgress == 0.0 || avatarProgress == 1.0 ? 0.0 : 0.75)
                                .frame(width: 102, height: 102)

                            Circle()
                                .foregroundColor(Color("baseButton"))
                                .frame(width: 90, height: 90, alignment: .center)

                            if (image == nil) {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color("disabledGray"))
                                    .frame(width: 24, height: 24, alignment: .center)
                            }
                        }
                    })
                    .buttonStyle(ClickInteractiveStyle(0.99))
//                    .sheet(isPresented: $showImagePicker) {
                        /*
                        ImagePickerHelper(sourceType: .photoLibrary) { (imageUrl, img) in
                            if let image = img {
                                self.image = Image(uiImage: image)
                            }

                            // FIXME: Upload avatar function here
                        }
                         */
//                    }

                    image?.resizable().scaledToFill().clipped().frame(width: 90, height: 90).cornerRadius(45)
                }

                Button("Select Avatar", action: {
                    showImagePicker.toggle()

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                })
                .buttonStyle(.bordered)
                .controlSize(.small)
                .buttonBorderShape(.roundedRectangle)

                Spacer()
                Text("decentralized by IPFS")
                    .fontTemplate(DefaultTemplate.caption)

                RoundedInteractiveButton("Next", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    nextView()
                })
                .padding(.bottom, 30)
            }.padding(.horizontal)
        }.navigationBarTitle("Set Avatar", displayMode: .inline)
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    nextView()
                }, label: Text("skip").foregroundColor(.secondary))
            }
        }
    }

    private func nextView() {
        store.checkNotificationPermission(completion: { isEnabled in
            if isEnabled {
                unauthenticatedRouter.route(to: \.completed)
            } else if !isEnabled {
                unauthenticatedRouter.route(to: \.notifications)
            }
        })

        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif
    }

}
