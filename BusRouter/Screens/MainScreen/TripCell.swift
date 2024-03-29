//
//  TripCell.swift
//  BusRouter
//
//  Created by Juan Colilla on 24/12/23.
//

import SeatCodeUI
import SwiftUI

struct TripCell: View {
  var trip: Trip
  var colorScheme: ColorScheme {
    return Current.colorScheme
  }
  var statusText: String {
    switch trip.status {
    case .scheduled, .ongoing:
      ""
    case .cancelled:
      "Cancelado"
    case .finalized:
      "Finalizado"
    case .other:
      "No disponible"
    }
  }

  var body: some View {
    ZStack {
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
      switch trip.status {
      case .scheduled, .ongoing:
        EmptyView()
      case .cancelled, .finalized, .other:
        Text(statusText)
          .padding(5)
          .background {
            BlurView(style: .light)
              .clipShape(RoundedRectangle(cornerRadius: 5.0))
          }
      }
    }
    .padding()
  }
}

#Preview {
  TripCell(
    trip: Trip(
      driverName: "Juan Perez",
      status: .cancelled,
      route: "Ruta 5",
      startTime: "08:00",
      endTime: "12:00",
      description: "Viaje a la ciudad",
      origin: Trip.Location(
        address: "Calle Falsa 123",
        point: Coordinate(latitude: -33.456, longitude: -70.657)
      ),
      destination: Trip.Location(
        address: "Avenida Siempre Viva 742",
        point: Coordinate(latitude: -33.123, longitude: -70.123)
      ),
      stops: [
        Trip.Stop(
          id: 1,
          point: Coordinate(latitude: -33.333, longitude: -70.333)
        ),
        Trip.Stop(
          id: 2,
          point: Coordinate(latitude: -33.444, longitude: -70.444)
        ),
      ]
    )
  )
  .previewLayout(.sizeThatFits)
}
