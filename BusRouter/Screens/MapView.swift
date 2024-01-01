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

fileprivate extension CLLocationCoordinate2D {
    static let seatCodeLocation: Self = CLLocationCoordinate2D(
        latitude: 41.38401,
        longitude: 2.17219
    )
}

struct MapView: View {
    
    var colorScheme: ColorScheme {
        return Current.colorScheme
    }
    
    @State
    private var sheetState: SheetState = .minimized
    
    @State
    private var camera: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: .seatCodeLocation,
            distance: 1000
        )
    )
    
    let store: StoreOf<MapReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                ZStack {
                    Map(position: $camera ) {
                        UserAnnotation()
                        if let tripRoute = viewStore.selectedTripRoute {
                            withAnimation(.default) {
                                MapPolyline(tripRoute)
                                .stroke(.blue, lineWidth: 5)
                            }
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .mapControls {
                        MapUserLocationButton()
                    }
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

#Preview {
    MapView(
        store: StoreOf<MapReducer>(
            initialState: MapReducer.State()
        ) {
            MapReducer()
        }
    )
}
