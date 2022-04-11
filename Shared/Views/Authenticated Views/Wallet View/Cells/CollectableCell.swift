//
//  CollectableCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/10/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectableCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: NftResult
    @State private var uriResponce: NftURIResponse?
    private let style: AppStyle
    private let action: () -> Void

    init(service: AuthenticatedServices, data: NftResult, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: { action() }, label: {
            VStack(alignment: .leading, spacing: 0) {
                if let uriResponce = uriResponce {
                    ListSection(hasPadding: false, style: service.themeStyle) {
                        if let imageData = uriResponce.imageData,
                           let data = imageData.data(using: .utf8),
                            let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
                                .padding([.top, .horizontal], 10)
                                .padding(.bottom, 5)
                        } else if let image = uriResponce.image {
                            WebImage(url: URL(string: image))
                                .resizable()
                                .placeholder { Rectangle().foregroundColor(Color("disabledGray")) }
                                .indicator(.activity)
                                .transition(.fade(duration: 0.35))
                                .scaledToFit()
                                .background(Color(!(uriResponce.backgroundColor?.isEmpty ?? true) ? uriResponce.backgroundColor ?? "baseBackground" : "baseBackground"))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
                                .padding([.top, .horizontal], 10)
                                .padding(.bottom, 5)
                        } else if let imageUrl = uriResponce.image_url {
                            WebImage(url: URL(string: imageUrl))
                                .resizable()
                                .placeholder { Rectangle().foregroundColor(Color("disabledGray")) }
                                .indicator(.activity)
                                .transition(.fade(duration: 0.35))
                                .scaledToFit()
                                .background(Color(!(uriResponce.backgroundColor?.isEmpty ?? true) ? uriResponce.backgroundColor ?? "baseBackground" : "baseBackground"))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
                                .padding([.top, .horizontal], 10)
                                .padding(.bottom, 5)
                        }

                        VStack(alignment: .leading, spacing: 2.5) {
                            Text(uriResponce.name ?? "no name")
                                .fontTemplate(DefaultTemplate.captionPrimary_semibold)
                                .lineLimit(2)
                                .padding(.horizontal, 10)

                            Text(uriResponce.nftURIResponseDescription ?? "")
                                .fontTemplate(DefaultTemplate.caption)
                                .lineLimit(3)
                                .padding([.bottom, .horizontal], 10)
                        }
                    }
                }
            }
        })
        .buttonStyle(ClickInteractiveStyle(0.98))
        .onAppear {
            if let metadata = data.metadata {
                self.service.wallet.decodeNftMetadata(metadata, completion: { responce in
                    self.uriResponce = responce
                    print("the metadata nft uri is: \(String(describing: responce))")
                })
            } else if let url = data.tokenURI {
                service.wallet.fetchNftUri(url, response: { uriResponce in
                    self.uriResponce = uriResponce
                    print("the web nft uri is: \(uriResponce)")
                })
            }
        }
    }

}
