//
//  TestView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/20/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

fileprivate struct DetailRow: View {
    let leftLabel: Text
    let rightLabe: Text
    
    var body: some View {
        HStack {
            leftLabel
                .font(.headline)
            Spacer()
            rightLabe
                .font(.callout)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
    }
}

struct TestView: View {
    let data = Array(1...5).map {"Item \($0)"}
    private static let horizontalSpacing: CGFloat = 15.0
    let layout = [
        GridItem(.flexible(), spacing: horizontalSpacing),
        GridItem(.flexible(), spacing: horizontalSpacing),
        GridItem(.flexible(), spacing: horizontalSpacing)
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
        ScrollView {
            
            LazyVGrid(columns: layout, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    //Text(item)
                    PlayerGridElement(player: testData[0])
                        //.font(.system(size: 40))
                }
            }
            .padding(.horizontal)
            }
        }
        .environment(\.colorScheme, ColorScheme.dark)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
