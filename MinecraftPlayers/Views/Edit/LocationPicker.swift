//
//  LocationPicker.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/3/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationPicker: View {
    @Environment(\.presentationMode) var isShowing
    @Binding var coordinateRegion: MKCoordinateRegion
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $coordinateRegion)
                .ignoresSafeArea(edges: .all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
    }
}

struct LocationPicker_Previews: PreviewProvider {
    static var previews: some View {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.89168, longitude: 27.54893), span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta: 11))
        LocationPicker(coordinateRegion: .constant(coordinateRegion))
    }
}
