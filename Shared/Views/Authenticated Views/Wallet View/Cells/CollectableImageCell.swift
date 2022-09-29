//
//  CollectableCell.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectableImageCell: View {

    @ObservedObject private var service: AuthenticatedServices

    private let data: NftResult
    @State private var uriResponce: NftURIResponse?
    private let style: AppStyle
    private let size: ControlSize
    private let action: () -> Void
    @State var svgLoadError: Bool = false

    init(service: AuthenticatedServices, data: NftResult, style: AppStyle, size: ControlSize? = .small, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.style = style
        self.size = size ?? .small
        self.action = action
    }

    var body: some View {
        Button(action: { action() }, label: {
            VStack(alignment: .leading, spacing: 0) {
                if let uriResponce = uriResponce {
                    ZStack(alignment: .bottomLeading) {
                        if uriResponce.isSVG() {
                            ZStack {
                                SVGWebView(uriResponce.image ?? uriResponce.image_url ?? "", isAvailable: $svgLoadError)
                                .aspectRatio(1, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))

                                if svgLoadError {
                                    Text("error loading image")                                    .fontTemplate(DefaultTemplate.bodySemibold_nunito)
                                        .padding()
                                }
                            }
                        } else if let imageData = uriResponce.imageData,
                           let data = imageData.data(using: .utf8),
                            let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                        } else if uriResponce.image != nil || uriResponce.image_url != nil {
                            WebImage(url: URL(string: uriResponce.image ?? uriResponce.image_url ?? ""))
                                .resizable()
                                .placeholder { Rectangle().foregroundColor(Color(UIColor.hexStringToUIColor(hex: uriResponce.backgroundColor ?? ""))) }
                                .indicator(.activity)
                                .scaledToFill()
                                .aspectRatio(contentMode: .fill)
                                .transition(.fade(duration: 0.35))
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                        }

                        service.wallet.getNetworkTransactImage(data.network ?? "")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 18, height: 18, alignment: .center)
                            .clipShape(Circle())
                            .padding(size == .small ? 5 : 7.5)
                    }
                } else {
                    ZStack(alignment: .bottomLeading) {
                        WebImage(url: URL(string: data.metadata?.imagePreview ?? data.metadata?.imageUrl ?? data.metadata?.image ?? ""))
                            .resizable()
                            .placeholder { Rectangle() }
                            .indicator(.activity)
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .transition(.fade(duration: 0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))

                        service.wallet.getNetworkTransactImage(data.network ?? "")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size == .small ? 14 : 18, height: size == .small ? 14 : 18, alignment: .center)
                            .clipShape(Circle())
                            .padding(size == .small ? 5 : 7.5)
                    }
                }

                Text(data.metadata?.name ?? data.name ?? "")
                    .fontTemplate(size == .small ? DefaultTemplate.captionPrimary_semibold : DefaultTemplate.bodySemibold_standard)
                    .lineLimit(3)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)

                Text(data.symbol ?? "")
                    .fontTemplate(DefaultTemplate.caption_Mono_secondary)
                    .lineLimit(1)
                    .padding([.horizontal, .bottom], 10)
            }
            .background(Color("baseButton"))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 10, x: 0, y: 5)
            .overlay(RoundedRectangle(cornerRadius: 15, style: .circular).strokeBorder(DefaultTemplate.borderColor, lineWidth: service.themeStyle == .shadow ? 1.0 : 1.35))
        }).buttonStyle(ClickInteractiveStyle(0.98))
        .onAppear {
//            if let metadata = data.metadata {
//                self.service.wallet.decodeNftMetadata(metadata.description, completion: { responce in
//                    self.uriResponce = responce
//                    print("the metadata nft uri is: \(String(describing: responce))")
//                })
//            } else

            loadTokenImage()
        }
    }

    private func loadTokenImage() {
        guard uriResponce == nil,
              let url = data.tokenURI,
              let storage = StorageService.shared.nftUriResponse else { return }

        storage.async.object(forKey: url) { result in
            switch result {
            case .value(let nftUri):
                print("my nft uri is: \(nftUri)")
                DispatchQueue.global(qos: .background).async {
                    self.uriResponce = nftUri
                }
            case .error:
                print("error")
                DispatchQueue.global(qos: .background).async {
                    service.wallet.fetchNftUri(url, response: { uriResponce in
                        self.uriResponce = uriResponce
                        print("the web nft uri is: \(uriResponce)")
                    })
                }
            }
        }
    }

}
