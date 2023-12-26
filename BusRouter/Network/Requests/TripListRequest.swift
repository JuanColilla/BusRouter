//
//  TripListRequest.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation

extension Endpoint {
  static var tripList: Self = Endpoint(appendingPath: "/tech-test/trips.json")
}

struct TripListRequest: APIRequest {
  var endpoint: Endpoint = .tripList
  var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  var body: [String: Any]? = nil
  var httpMethod: HTTPMethod = .GET
}
