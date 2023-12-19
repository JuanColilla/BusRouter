//
//  MapView.swift
//  BusRouter
//
//  Created by Juan Colilla on 17/12/23.
//

import MapKit
import SwiftUI
import SeatCodeUI

struct MapView: View {
    // Define una región inicial para el mapa
    // Coordenadas de ejemplo (Nueva York)
    @State
    private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    @State
    private var sheetState: SheetState = .minimized
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
            Map(coordinateRegion: $region)
                .ignoresSafeArea(.all)
            BottomSheetView(
                sheetState: $sheetState,
                maxHeight: geometry.size.height * 0.9
            ) {
                VStack(alignment: .center) {
                    ForEach(0..<5, id: \.self) { index in
                        Text("Item \(index)")
                    }
                }
            }
        }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    MapView()
}
