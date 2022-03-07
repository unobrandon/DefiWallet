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

    @State var disablePrimaryAction: Bool = false
    @State var showImagePicker: Bool = false
//    @State private var image: Image? = nil
//    @State private var inputImage: UIImage? = nil
    @State private var avatarProgress: Double = 0.0

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                HeaderIcon(size: 48, imageName: "person.circle")
                    .padding(.bottom, 10)

                Text("Profile avatar")
                    .fontTemplate(DefaultTemplate.headingSemiBold)
                    .multilineTextAlignment(.center)

                Text("Upload an avatar that will be linked to your universal ENS username")
                    .fontTemplate(DefaultTemplate.bodyMono_secondary)
                    .multilineTextAlignment(.center)

                Spacer()
                ZStack(alignment: .center) {
                    Button(action: {
                        #if os(iOS)
                            withAnimation { showImagePicker.toggle() }

                            HapticFeedback.lightHapticFeedback()
                        #endif
                    }) {
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

//                            if (image == nil) {
                                VStack {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .foregroundColor(Color.secondary)
                                        .frame(width: 27, height: 25, alignment: .center)

                                    Text("select avatar")
                                        .fontTemplate(DefaultTemplate.alertMessage)
                                }
//                            }
                        }
                    }
                    .buttonStyle(ClickInteractiveStyle())
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

//                    image?.resizable().scaledToFill().clipped().frame(width: 90, height: 90).cornerRadius(45)
                }

                Spacer()
                Text("decentralized by IPFS")
                    .fontTemplate(DefaultTemplate.caption)

                RoundedInteractiveButton("Next", isDisabled: $disablePrimaryAction, style: .primary, systemImage: nil, action: {
                    nextView()
                })
                .padding(.vertical)
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
            } else {
                unauthenticatedRouter.route(to: \.notifications)
            }
        })

        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif
    }

}
