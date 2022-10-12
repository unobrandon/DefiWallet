//
//  CollectableDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 10/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectableDetailView: View {

    @EnvironmentObject var walletRouter: WalletCoordinator.Router
    @EnvironmentObject var marketRouter: MarketsCoordinator.Router

    @ObservedObject var service: AuthenticatedServices
    @ObservedObject var wallet: WalletService

    @State var data: NftResult
    @State private var uriResponce: NftURIResponse?
    @State var scrollOffset: CGFloat = CGFloat.zero
    @State private var imageSize = CGSize.zero
    @State var openLinkSheet: Bool = false
    @State var svgLoadError: Bool = false

    let fromMarketView: Bool

    init(fromMarketView: Bool? = nil, data: NftResult, service: AuthenticatedServices) {
        self.fromMarketView = fromMarketView ?? false
        self.data = data
        self.service = service
        self.wallet = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {
                if let uriResponce = uriResponce {
                    ZStack(alignment: .bottomLeading) {
                        if uriResponce.isSVG() {
                            ZStack {
                                SVGWebView(uriResponce.image ?? uriResponce.image_url ?? "", isAvailable: $svgLoadError)
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 0, style: .circular))
                                    .zIndex(5)
                                    .pinchToZoom()

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
                                .clipShape(RoundedRectangle(cornerRadius: 0, style: .circular))
                                .zIndex(5)
                                .pinchToZoom()
                        } else if uriResponce.image != nil || uriResponce.image_url != nil {
                            WebImage(url: URL(string: uriResponce.image ?? uriResponce.image_url ?? ""))
                                .resizable()
                                .placeholder { Rectangle().foregroundColor(Color(UIColor.hexStringToUIColor(hex: uriResponce.backgroundColor ?? ""))) }
                                .indicator(.activity)
                                .scaledToFill()
                                .aspectRatio(contentMode: .fill)
                                .transition(.fade(duration: 0.35))
                                .clipShape(RoundedRectangle(cornerRadius: 0, style: .circular))
                                .zIndex(5)
                                .pinchToZoom()
                        }

//                        service.wallet.getNetworkTransactImage(data.network ?? "")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 18, height: 18, alignment: .center)
//                            .clipShape(Circle())
//                            .padding(size == .small ? 5 : 7.5)
                    }
                    .measureSize { size in
                        imageSize = size
                    }
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("collectableDetail-scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        self.scrollOffset = $0
                        print("the offset is: \($0) and image height: \(imageSize.height)")
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
                            .clipShape(RoundedRectangle(cornerRadius: 0, style: .circular))
                            .zIndex(5)
                            .pinchToZoom()

//                        service.wallet.getNetworkTransactImage(data.network ?? "")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: size == .small ? 14 : 18, height: size == .small ? 14 : 18, alignment: .center)
//                            .clipShape(Circle())
//                            .padding(size == .small ? 5 : 7.5)
                    }
                    .measureSize { size in
                        imageSize = size
                    }
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("collectableDetail-scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        self.scrollOffset = $0
                        print("the offset is: \($0) and image height: \(imageSize.height)")
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(data.metadata?.name ?? data.name ?? "")
                        .fontTemplate(DefaultTemplate.titleSemiBold)
                        .lineLimit(4)

                    Text(data.symbol ?? "")
                        .fontTemplate(DefaultTemplate.body_Mono_secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)
                .padding([.horizontal, .bottom], 10)
                Spacer()

                FooterInformation()
                    .padding(.vertical, 60)
            }.coordinateSpace(name: "collectableDetail-scroll")
        })
        .navigationBarTitle {
            HStack(alignment: .center, spacing: 10) {
                if self.scrollOffset > imageSize.height + 30 {
                    Text(data.metadata?.name ?? data.name ?? "")
                        .fontTemplate(DefaultTemplate.sectionHeader_bold)
                        .lineLimit(1)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            loadCollectableImage()
        }
    }

    private func loadCollectableImage() {
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
