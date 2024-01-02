//
//  StopInfoRequest.swift
//  BusRouter
//
//  Created by Juan Colilla on 2/1/24.
//

import Foundation

extension Endpoint {
  static let stopInfo: Self = Endpoint(appendingPath: "/tech-test/stops.json")
}

struct StopInfoRequest: APIRequest {
  var endpoint: Endpoint = .stopInfo
  var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  var body: [String: Any]? = nil
  var httpMethod: HTTPMethod = .GET
}
