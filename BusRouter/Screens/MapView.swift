//
//  MapView.swift
//  BusRouter
//
//  Created by Juan Colilla on 17/12/23.
//

import MapKit
import SwiftUI
import SeatCodeUI
import ComposableArchitecture

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
        WithViewStore(store, observe: {$0}) { viewStore in
            GeometryReader { geometry in
                ZStack {
                    Map(coordinateRegion: $region)
                        .ignoresSafeArea(.all)
                    BottomSheetView(
                        sheetState: $sheetState,
                        maxHeight: geometry.size.height * 0.9
                    ) {
                        VStack(alignment: .center) {
                            if case .success(let trips) = viewStore.tripList {
                                ScrollView {
                                    ForEach(trips, id: \.self) { trip in
                                        VStack {
                                            RouteCell(
                                                origin: trip.origin.address,
                                                destination: trip.destination.address
                                            )
                                            Divider()
                                        }
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

struct RouteCell: View {
    var origin: String
    var destination: String
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(origin)
            Image(systemName: "arrow.down")
            Text(destination)
        }
    }
}

struct MapReducer: Reducer {
    
    enum Action: Equatable {
        case onAppear
        case _fetchTrips
        case _tripsReceived([Trip])
        case _failedToFetchTrips(APIError)
    }
    struct State: Equatable {
        var tripList: RemoteResult<[Trip], APIError> = .idle
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(._fetchTrips)
            case ._fetchTrips:
                state.tripList = .loading
                return .run { send in
                    let apiResult: Result<[Trip], APIError> = await FetchTripsUseCase().execute()
                    switch apiResult {
                    case .success(let tripList):
                        await send(._tripsReceived(tripList))
                    case .failure(let error):
                        await send(._failedToFetchTrips(error))
                    }
                }
            case ._tripsReceived(let tripList):
                state.tripList = .success(tripList)
                return .none
            case ._failedToFetchTrips(let error):
                state.tripList = .failure(error)
                return .none
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
