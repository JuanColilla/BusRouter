//
//  MapReducer.swift
//  BusRouter
//
//  Created by Juan Colilla on 24/12/23.
//

import ComposableArchitecture
import Foundation

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
