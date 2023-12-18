//
//  MapView.swift
//  BusRouter
//
//  Created by Juan Colilla on 17/12/23.
//

import MapKit
import SwiftUI

struct MapView: View {
  // Define una región inicial para el mapa
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),  // Coordenadas de ejemplo (Nueva York)
    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
  )

  @State
  private var isListPresented: Bool = true

  var body: some View {
    // Crea un mapa que esté vinculado a la región
    Map(coordinateRegion: $region)
      .ignoresSafeArea(.all)
      .sheet(
        isPresented: $isListPresented,
        onDismiss: {

        },
        content: {
          VStack {
            ForEach(0..<5, id: \.self) { index in
              Text("Item \(index)")
            }
          }
        })
  }
}

#Preview {
  MapView()
}
