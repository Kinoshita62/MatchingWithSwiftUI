//
//  BrandImage.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/07.
//

import SwiftUI

enum BrandImageSize: CGFloat {
    case large = 120
    case small = 32
}

struct BrandImage: View {
    
    let size: BrandImageSize
    
    var body: some View {
        LinearGradient(
            colors: [.brandColorLight, .brandColorDark],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .mask(
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
        )
        .frame(width: size.rawValue, height: size.rawValue)
    }
}

#Preview {
    BrandImage(size: .large)
}
