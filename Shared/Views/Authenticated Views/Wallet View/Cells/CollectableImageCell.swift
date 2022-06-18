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
    private let action: () -> Void
    @State var svgLoadError: Bool = false

    init(service: AuthenticatedServices, data: NftResult, style: AppStyle, action: @escaping () -> Void) {
        self.service = service
        self.data = data
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: { action() }, label: {
            VStack {
                if let uriResponce = uriResponce {
                    if uriResponce.isSVG() {
                        ZStack {
                            SVGWebView(uriResponce.image ?? uriResponce.image_url ?? "", isAvailable: $svgLoadError)
                            .aspectRatio(1, contentMode: .fill)

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
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    } else if uriResponce.image != nil || uriResponce.image_url != nil {
                        WebImage(url: URL(string: uriResponce.image ?? uriResponce.image_url ?? ""))
                            .resizable()
                            .placeholder { Rectangle().foregroundColor(Color(UIColor.hexStringToUIColor(hex: uriResponce.backgroundColor ?? ""))) }
                            .indicator(.activity)
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .transition(.fade(duration: 0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    }
                } else {
                    WebImage(url: URL(string: data.metadata?.imagePreview ?? data.metadata?.imageUrl ?? data.metadata?.image ?? ""))
                        .resizable()
                        .placeholder { Rectangle() }
                        .indicator(.activity)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .transition(.fade(duration: 0.35))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                }

                Text(data.metadata?.name ?? data.name ?? "")
                    .fontTemplate(DefaultTemplate.body)
            }
        }).buttonStyle(ClickInteractiveStyle(0.98))
        .onAppear {
//            if let metadata = data.metadata {
//                self.service.wallet.decodeNftMetadata(metadata, completion: { responce in
//                    self.uriResponce = responce
//                    print("the metadata nft uri is: \(String(describing: responce))")
//                })
//            } else if let url = data.tokenURI {
//                service.wallet.fetchNftUri(url, response: { uriResponce in
//                    self.uriResponce = uriResponce
//                    print("the web nft uri is: \(uriResponce)")
//                })
//            }
        }
    }

}
