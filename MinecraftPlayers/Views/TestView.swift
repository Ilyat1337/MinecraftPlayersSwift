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
    
    @State var output: String = ""
    @State var input: String = ""
    @State var typing = false
    @State var temp = ""
    var body: some View {
        VStack {
            if !typing {
                if !output.isEmpty {
                    Text("You typed: \(output)")
                }
            } else if !input.isEmpty {
                Text("You are typing: \(input)")
            }
            TextField("", text: $input, onEditingChanged: {
                print("Is typing: \($0)")
                self.typing = $0
            }, onCommit: {
                print("On commit")
                self.output = self.input
            })
            TextField("Ok!", text: $temp)
            .background(Color.green.opacity(0.2))
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
