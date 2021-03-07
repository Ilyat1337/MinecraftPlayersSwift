//
//  TestView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/20/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import MapKit

struct TestView: View {
    @State var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.89168, longitude: 27.54893), span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta: 11))
    @State var isShowingLocationPicker = false
    let fontNames = ["Helvetica", "Avenir Next", "Noteworthy", "Papyrus", "Chalkboard SE"]
    
    var body: some View {
        VStack {
            Button("Show!!", action: { isShowingLocationPicker.toggle() })
            Text("\(coordinateRegion.center.latitude)")
            Text("\(coordinateRegion.center.longitude)")
            
                Text("Hello world!")
                Text("Hello world!")
                    .font(.system(size: 17))
                Text("Hello world!")
                    .font(.custom("Helvetica", size: 17))
            Text("Hello world!")
                .font(.custom("Avenir Next", size: 17))
            Text("Hello world!")
                .font(.custom("Noteworthy", size: 17))
            Text("Hello world!")
                .font(.custom("Papyrus", size: 17))
            Text("Hello world!")
                .font(.custom("Chalkboard SE", size: 17))
            
            
        }
        .fullScreenCover(isPresented: $isShowingLocationPicker) {
            LocationPicker(coordinateRegion: $coordinateRegion)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
