//
//  RouteCell.swift
//  BusRouter
//
//  Created by Juan Colilla on 24/12/23.
//

import SwiftUI

struct RouteCell: View {
  var trip: Trip
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "person.fill")
        Text(trip.driverName)
        Spacer()
        Text(trip.startTime.shortHour())
      }
      HStack {
        Spacer()
        Image(systemName: "arrow.down")
          .padding(.trailing)
      }
      .padding(.vertical, 1)
      HStack {
        Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
        Text(trip.description)
        Spacer()
        Text(trip.endTime.shortHour())
      }
    }
    .padding()
  }
}

#Preview {
  RouteCell(
    trip: Trip(
      driverName: "Juan Perez",
      status: "En ruta",
      route: "Ruta 5",
      startTime: "08:00",
      endTime: "12:00",
      description: "Viaje a la ciudad",
      origin: Trip.Location(
        address: "Calle Falsa 123",
        point: Trip.Location.Coordinate(_latitude: -33.456, _longitude: -70.657)
      ),
      destination: Trip.Location(
        address: "Avenida Siempre Viva 742",
        point: Trip.Location.Coordinate(_latitude: -33.123, _longitude: -70.123)
      ),
      stops: [
        Trip.Stop(
          id: 1,
          point: Trip.Location.Coordinate(_latitude: -33.333, _longitude: -70.333)
        ),
        Trip.Stop(
          id: 2,
          point: Trip.Location.Coordinate(_latitude: -33.444, _longitude: -70.444)
        ),
      ]
    )
  )
  .previewLayout(.sizeThatFits)
}
