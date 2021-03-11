//
//  GridImageGallery.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/11/21.
//

import SwiftUI

fileprivate struct ImagePreview: View {
    var image: Image
    var borderColor: Color
    var imageSize: CGFloat
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: imageSize, height: imageSize, alignment: .center)
            .clipped()
            .border(borderColor, width: 1)
    }
}

struct GridImageGallery: View {
    private static let imagesPerRow = 3
    private let layout = Array(repeating: GridItem(.flexible(), spacing: 0), count: imagesPerRow)
    
    @EnvironmentObject private var settings: SettingsStore
    
    var images: [UIImage]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 0) {
                ForEach(0..<images.count, id: \.self) { index in
                    NavigationLink(destination: ImageGallery(images: images, selectedTab: index)) {
                        ImagePreview(
                            image: Image(uiImage: images[index]),
                            borderColor: settings.color,
                            imageSize: UIScreen.main.bounds.width / CGFloat(GridImageGallery.imagesPerRow))
                    }
                }
            }
        }
    }
}

struct GridImageGallery_Previews: PreviewProvider {
    static var previews: some View {
        let images = (0..<2).map { _ in return getPlayerForPreview().images! }.flatMap { $0 }
        NavigationView {
            GridImageGallery(images: images)
                .environmentObject(getResetSettings())
                .navigationBarHidden(true)
        }
    }
}
