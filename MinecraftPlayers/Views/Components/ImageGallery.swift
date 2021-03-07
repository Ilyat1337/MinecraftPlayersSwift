//
//  ImageGallery.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/6/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct ImageGallery: View {
    @State private var imageScale: CGFloat = 1.0
    var images: [Image]
    @State var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ForEach(0..<images.count) { index in
                    images[index]
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(imageScale)
                        .gesture(MagnificationGesture()
                            .onChanged { scale in
                                if scale < 1 {
                                    self.imageScale = 1
                                } else {
                                    self.imageScale = scale
                                }
                            })
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: selectedTab) { _ in
                imageScale = 1
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(selectedTab + 1)\\\(images.count)")
                    Spacer()
                }
            }
        }
    }
}

struct ImageGallery_Previews: PreviewProvider {
    static var previews: some View {
        ImageGallery(images: getPlayerForPreview().images!)
    }
}
