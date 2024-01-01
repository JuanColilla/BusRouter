//
//  Trip.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import CoreLocation
import Foundation

struct Trip: Codable, Equatable, Hashable {
  var driverName: String
  var status: Trip.Status
  var route: String
  var startTime: String
  var endTime: String
  var description: String
  var origin: Location
  var destination: Location
  var stops: [Stop]

  struct Location: Codable, Equatable, Hashable {
    var address: String
    var point: Coordinate

    struct Coordinate: Codable, Equatable, Hashable {
      var _latitude: CLLocationDegrees
      var _longitude: CLLocationDegrees
    }
  }

  struct Stop: Codable, Equatable, Hashable {
    var id: Int?
    var point: Location.Coordinate?
  }
}

extension Trip {
  enum Status: RawRepresentable, Codable, Equatable, Hashable {
    typealias RawValue = String
    case scheduled, ongoing, cancelled, finalized, other

    var rawValue: String {
      switch self {
      case .scheduled: return "scheduled"
      case .ongoing: return "ongoing"
      case .cancelled: return "cancelled"
      case .finalized: return "finalized"
      case .other: return "other"
      }
    }

    init(rawValue: String) {
      switch rawValue {
      case "scheduled": self = .scheduled
      case "ongoing": self = .ongoing
      case "cancelled": self = .cancelled
      case "finalized": self = .finalized
      default: self = .other
      }
    }
  }
}
