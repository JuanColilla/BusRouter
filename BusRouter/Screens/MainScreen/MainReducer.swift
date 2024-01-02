//
//  MapReducer.swift
//  BusRouter
//
//  Created by Juan Colilla on 24/12/23.
//

import ComposableArchitecture
import CoreLocation
import MapKit
import Polyline
import SeatCodeUI

struct MainReducer: Reducer {

  // MARK: Task IDs for cancellation
  enum CancellableTaskID: Hashable {
    case updateLocation
  }

  // MARK: Actions
  enum Action: Equatable {
    case onAppear
    case checkLocationPermission
    case updateLocation
    case selectTrip(Trip)

    case _newLocationReceived(CLLocation)
    case _locationNotAllowed
    case _fetchTrips
    case _tripsReceived([Trip])
    case _failedToFetchTrips(APIError)
    case _fetchStops
    case _stopsReceived(Stop)
    case _failedToFetchStops(APIError)
    case _none
  }

  // MARK: State
  struct State: Equatable {
    var tripList: RemoteResult<[Trip], APIError> = .idle

    var selectedTrip: Trip? = nil
    var location: CLLocationCoordinate2D? = nil
    var selectedTripRoute: MKPolyline? = nil
    var selectedTripStopInfo: RemoteResult<StopMarker.StopInfo, APIError> = .idle

    var stopInfo: StopMarker.StopInfo? {
      if case .success(let stopInfo) = selectedTripStopInfo {
        return stopInfo
      } else {
        return nil
      }
    }

    var selectedTripRouteStops: [CLLocationCoordinate2D]? {
      guard let selectedTrip else { return nil }
      return Polyline(encodedPolyline: selectedTrip.route).coordinates
    }
  }

  // MARK: Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .merge(
          .send(.checkLocationPermission),
          .send(._fetchTrips)
        )
      case .checkLocationPermission:
        return .publisher {
          Current.locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .map { authorizationStatus in
              switch authorizationStatus {
              case .authorizedAlways, .authorizedWhenInUse:
                return MainReducer.Action.updateLocation
              default:
                return MainReducer.Action._locationNotAllowed
              }
            }
        }
      case .updateLocation:
        return .publisher {
          Current.locationManager.$location
            .receive(on: DispatchQueue.main)
            .map { location in
              guard let location else { return ._none }
              return MainReducer.Action._newLocationReceived(location)
            }
        }
        .cancellable(id: CancellableTaskID.updateLocation)
      case .selectTrip(let trip):
        if state.selectedTrip == trip {
          state.selectedTrip = nil
          return .none
        }
        if trip.status == .ongoing || trip.status == .scheduled {
          state.selectedTrip = trip
          state.selectedTripRoute = Polyline.init(encodedPolyline: trip.route).mkPolyline
        }
        return .send(._fetchStops)
      case ._newLocationReceived(let location):
        state.location = location.coordinate
        return .cancel(id: CancellableTaskID.updateLocation)
      case ._fetchTrips:
        state.tripList = .loading
        return .run { send in
          let tripResult: Result<[Trip], APIError> = await FetchTripsUseCase().execute()
          switch tripResult {
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
      case ._fetchStops:
        state.selectedTripStopInfo = .loading
        return .run { send in
          let stopInfoResult = await FetchStopInfoUseCase().execute()
          switch stopInfoResult {
          case .success(let stopInfo):
            await send(._stopsReceived(stopInfo))
          case .failure(let error):
            await send(._failedToFetchStops(error))
          }
        }
      case ._stopsReceived(let stop):
        state.selectedTripStopInfo = .success(
          StopMarker.StopInfo(
            passengerName: stop.userName,
            address: stop.address,
            stopTime: stop.stopTime.shortHour(),
            paid: stop.paid,
            price: stop.price
          )
        )
        return .none
      case ._failedToFetchStops(let error):
        return .none
      case ._locationNotAllowed:
        return .none
      case ._none:
        return .none

      }
    }
  }
}

// MARK: MKCoordinateRegion Equatable Extension
extension MKCoordinateRegion: Equatable {
  public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
    return lhs.center.latitude == rhs.center.latitude
      && lhs.center.longitude == rhs.center.longitude
      && lhs.span.latitudeDelta == rhs.span.latitudeDelta
      && lhs.span.longitudeDelta == rhs.span.longitudeDelta
  }
}
