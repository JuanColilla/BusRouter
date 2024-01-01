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

struct MainView: View {

  // MARK: View State Properties
  @State
  private var sheetState: SheetState = .minimized

  @State
  private var camera: MapCameraPosition = .camera(
    MapCamera(
      centerCoordinate: .seatCodeLocation,
      distance: 1000
    )
  )

  // MARK: ViewStore
  let store: StoreOf<MapReducer>

  var colorScheme: ColorScheme {
    return Current.colorScheme
  }

  // MARK: View Body
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { geometry in
        ZStack {
          MapView(
            camera: $camera,
            route: viewStore.selectedTrip != nil ?
            MapView.Route(
                origin: viewStore.selectedTrip!.origin.point.cllocationCoordinate2D,
                stops: viewStore.selectedTripRouteStops!,
                destination: viewStore.selectedTrip!.destination.point.cllocationCoordinate2D,
                polyline: viewStore.selectedTripRoute!
            ) : nil
            
          )
          // MARK: Map Observers
          .onChange(of: viewStore.location) { _, newLocation in
            guard let newLocation else { return }
            camera = .camera(
              MapCamera(
                centerCoordinate: newLocation,
                distance: 1000
              )
            )
          }
          .onChange(of: viewStore.selectedTrip) { _, selectedTrip in
            if selectedTrip == nil {
              withAnimation {
                camera = .camera(
                  MapCamera(
                    centerCoordinate: viewStore.location ?? .seatCodeLocation,
                    distance: 1000
                  )
                )
              }
            }
          }
          BottomSheetView(
            sheetState: $sheetState,
            maxHeight: geometry.size.height * 0.9,
            colorScheme: colorScheme
          ) {
            VStack(alignment: .center) {
              HStack {
                Image(systemName: "bus")
                Text("Rutas de autobus")
                  .fontWeight(.bold)
                  .padding()
              }
              .padding(.top, sheetState == .minimized ? 30 : 5)
              Divider()
              if case .success(let trips) = viewStore.tripList {
                ScrollView {
                  ForEach(trips, id: \.self) { trip in
                    TripCell(trip: trip)
                      .onTapGesture {
                        viewStore.send(.selectTrip(trip))
                        if trip.status == .ongoing || trip.status == .scheduled {
                          withAnimation {
                            sheetState = .minimized
                            camera = .automatic
                          }
                        }
                      }
                    Divider()
                  }
                }
                .frame(
                  height: sheetState == .half
                    ? geometry.size.height * 0.3 : geometry.size.height * 0.75
                )
              } else if case .loading = viewStore.tripList {
                Text("Cargando viajes...")
              } else {
                Text("Ningún viaje")
              }
            }
          }
          .ignoresSafeArea(.all)
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
    
}

// MARK: Default Location
extension CLLocationCoordinate2D {
  fileprivate static let seatCodeLocation: Self = CLLocationCoordinate2D(
    latitude: 41.38401,
    longitude: 2.17219
  )
}

#Preview {
  MainView(
    store: StoreOf<MapReducer>(
      initialState: MapReducer.State()
    ) {
      MapReducer()
    }
  )
}
