//
//  RemoteImage.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/20/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct RemoteImage: View {

    private let imageUrl: String
    private let size: CGFloat?
    private var fullSize: CGSize?

    init(_ url: String, size: CGFloat? = nil, fullSize: CGSize? = nil) {
        self.imageUrl = url
        self.size = size
        self.fullSize = fullSize
    }

    var body: some View {
        WebImage(url: URL(string: imageUrl))
            .resizable()
            .placeholder { Rectangle().foregroundColor(Color("disabledGray")) }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.35)) // Fade Transition with duration
            .scaledToFill()
            .frame(width: fullSize?.width ?? size ?? nil, height: fullSize?.height ?? size ?? nil, alignment: .center)
            .background(Color("baseBackground"))
    }

}

/*
class RemoteImageURL: ObservableObject {

    @Published var data: Data = Data()

    init(imageURL: String) {
        do {
            let data = try StorageService.shared.dataStorage?.object(forKey: imageURL)

            guard let data = data else { return }

            DispatchQueue.main.async {
                self.data = data
            }
        } catch {
            guard let url = URL(string: imageURL) else { return }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else { return }

                DispatchQueue.main.async {
                    self.data = data

                    guard let imageStore = StorageService.shared.dataStorage?.transformCodable(ofType: Data.self) else { return }

                    do {
                        try imageStore.setObject(data, forKey: imageURL, expiry: .date(Date().addingTimeInterval(2*3600)))
                        print("done setting new image")
                    } catch {
                        print("complete error getting image")
                    }
                }
            }.resume()
        }
    }

}
*/
