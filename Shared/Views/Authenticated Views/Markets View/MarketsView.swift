//
//  MarketsView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen

struct MarketsView: View {

    init() {
        print("markets view did inittt")
    }

    var body: some View {
        ZStack {
            Color("baseBackground").ignoresSafeArea()
   
            ScrollView {
                Text("It's the market view!!")
            }
        }
        .navigationTitle("Market")
    }

}
