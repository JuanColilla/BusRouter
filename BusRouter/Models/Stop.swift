//
//  Stop.swift
//  BusRouter
//
//  Created by Juan Colilla on 2/1/24.
//

import Foundation

struct Stop: Codable, Equatable, Identifiable, Hashable {
    var id: Int            // Unique identifier for the Stop, using tripId as it's unique for each stop
    var stopTime: String   // Timestamp of the stop
    var paid: Bool         // If the user has paid or not
    var address: String    // Address of the stop
    var userName: String   // The name of the passenger
    var point: Coordinate  // Latitude and longitude of the stop
    var price: Double      // Price of the stop
    
    enum CodingKeys: String, CodingKey {
        case stopTime, paid, address, userName, point, price
        case id = "tripId"
    }
}
