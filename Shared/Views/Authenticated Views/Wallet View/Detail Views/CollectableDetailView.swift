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
                                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                                    .padding(.horizontal, 10)
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
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                                .padding(.horizontal, 10)
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
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                                .padding(.horizontal, 10)
                                .zIndex(5)
                                .pinchToZoom()
                        }
                    }
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("collectableDetail-scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        self.scrollOffset = $0
                    }
                } else {
                    WebImage(url: URL(string: data.metadata?.imagePreview ?? data.metadata?.imageUrl ?? data.metadata?.image ?? ""))
                        .resizable()
                        .placeholder { Rectangle() }
                        .indicator(.activity)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .transition(.fade(duration: 0.35))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                        .padding(.horizontal, 10)
                        .zIndex(5)
                        .pinchToZoom()
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named("collectableDetail-scroll")).origin.y)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) {
                            self.scrollOffset = $0
                        }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(data.metadata?.name ?? data.name ?? "")
                        .fontTemplate(DefaultTemplate.headingSemiBold)
                        .lineLimit(4)

                    Text(data.symbol?.capitalized ?? "")
                        .fontTemplate(DefaultTemplate.body_standard)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)
                .padding(.horizontal)
                .padding([.horizontal, .bottom])

                if let description = data.metadata?.description, !description.isEmpty {
                    ListTitleView(title: "Description", showDivider: false, style: service.themeStyle)

                    ListSection(hasPadding: true, style: service.themeStyle) {
                        HStack(alignment: .center, spacing: 0) {
                            ViewMoreText(description, isCaption: false, lineLimit: 5)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            Spacer()
                        }

                        if service.themeStyle == .shadow {
                            Divider().padding(.leading)
                        } else if service.themeStyle == .border {
                            Rectangle().foregroundColor(DefaultTemplate.borderColor)
                                .frame(height: 1)
                        }
                    }
                }

                ListTitleView(title: "Details", showDivider: false, style: service.themeStyle)

                ListSection(style: service.themeStyle) {
                    ListInfoView(title: "Address", info:data.tokenAddress?.formatAddress(8) ?? "", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Owner", info: data.ownerOf?.formatAddress(8) ?? "", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Quantity", info: data.amount ?? "", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Block Number Minted", info: data.blockNumberMinted ?? "", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Block Number", info: data.blockNumber ?? "", style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Network", info: (data.network == "bsc" ? "Binance": data.network?.uppercased() ?? ""), style: service.themeStyle, isLast: false)

                    ListInfoView(title: "Contract Type", info: data.contractType ?? "", style: service.themeStyle, isLast: false)

                    if let externalUrl = data.metadata?.externalUrl ?? data.metadata?.url, !externalUrl.isEmpty {
                        ListStandardButton(title: "External Link", systemImage: "safari", isLast: true, style: service.themeStyle, action: {
                            openLink(externalUrl)
                        })
                    }
                }

                FooterInformation()
                    .padding(.top, 40)
                    .padding(.bottom)
            }.coordinateSpace(name: "collectableDetail-scroll")
        })
        .navigationBarTitle {
            HStack(alignment: .center, spacing: 10) {
                if self.scrollOffset > 100 {
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

    private func openLink(_ link: String) {
        if fromMarketView {
            marketRouter.route(to: \.safari, link)
        } else {
            walletRouter.route(to: \.safari, link)
        }
    }

}
