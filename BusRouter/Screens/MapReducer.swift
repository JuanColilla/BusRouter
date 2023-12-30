//
//  MapReducer.swift
//  BusRouter
//
//  Created by Juan Colilla on 24/12/23.
//

import ComposableArchitecture
import CoreLocation
import MapKit

enum CLError: LocalizedError, Equatable {
    case permissionDenied
    case other
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
            return lhs.center.latitude == rhs.center.latitude &&
                   lhs.center.longitude == rhs.center.longitude &&
                   lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
                   lhs.span.longitudeDelta == rhs.span.longitudeDelta
        }
}

struct MapReducer: Reducer {
    
    enum CancellableTaskID: Hashable {
        case updateLocation
    }

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
        case _none
    }
    
  struct State: Equatable {
    var tripList: RemoteResult<[Trip], APIError> = .idle
      var userLocation: CLLocation = CLLocation(latitude: 41.38401, longitude: 2.17219)
      var selectedTripRoute: [CLLocationCoordinate2D]? = nil
      var selectedTrip: Trip? = nil
  }

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
                          return MapReducer.Action.updateLocation
                      default:
                          return MapReducer.Action._locationNotAllowed
                      }
                  }
          }
      case .updateLocation:
          return .publisher {
              Current.locationManager.$location
                  .receive(on: DispatchQueue.main)
                  .map { location in
                      guard let location else { return ._none }
                      return MapReducer.Action._newLocationReceived(location)
                  }
          }
          .cancellable(id: CancellableTaskID.updateLocation)
      case .selectTrip(let trip):
          state.selectedTrip = trip
          state.selectedTripRoute = trip.stops.map { CLLocationCoordinate2D(latitude: $0.point?._latitude ?? 0.0, longitude: $0.point?._latitude ?? 0.0) }
          return .none
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
      case ._newLocationReceived(let location):
          state.userLocation = location
          return .cancel(id: CancellableTaskID.updateLocation)
      case ._locationNotAllowed:
          return .none
      case ._none:
          return .none
      }
    }
  }
}

import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    // MARK: Delegate Publisheres
    @Published
    var location: CLLocation?
    
    @Published
    var authorizationStatus: CLAuthorizationStatus

    override init() {
        // LocationManagerDelegate Properties Initialization
        self.authorizationStatus = .notDetermined
        
        // Parent Constructor Initialization
        super.init()
        
        // Delegate Functions Execution
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.authorizationStatus = locationManager.authorizationStatus
        self.locationManager.startUpdatingLocation()
    }

    // MARK: Delegate Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return } 
        self.location = location
    }
    
    // Handle the failure case
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
