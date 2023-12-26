//
//  MapView.swift
//  BusRouter
//
//  Created by Juan Colilla on 17/12/23.
//

import ComposableArchitecture
import MapKit
import SeatCodeUI
import SwiftUI

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

  let store: StoreOf<MapReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { geometry in
        ZStack {
          Map(coordinateRegion: $region)
            .ignoresSafeArea(.all)
          BottomSheetView(
            sheetState: $sheetState,
            maxHeight: geometry.size.height * 0.9
          ) {
            VStack(alignment: .center) {
              HStack {
                Image(systemName: "bus")
                Text("Rutas de autobus")
                  .fontWeight(.bold)
                  .padding()
              }
              .padding(.top)
              Divider()
              if case .success(let trips) = viewStore.tripList {
                ScrollView {
                  ForEach(trips, id: \.self) { trip in
                    RouteCell(
                      description: trip.description
                    )
                    Divider()
                  }
                }
              } else if case .loading = viewStore.tripList {
                Text("Cargando viajes...")
              } else {
                Text("Ningún viaje")
              }
            }
          }
        }
      }
      .ignoresSafeArea(.all)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

#Preview {
  MapView(
    store: StoreOf<MapReducer>(
      initialState: MapReducer.State()
    ) {
      MapReducer()
    }
  )
}
