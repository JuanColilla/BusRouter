//
//  SwiftUIView.swift
//
//
//  Created by Juan Colilla on 1/1/24.
//

import CoreLocation
import MapKit
import SwiftUI

public struct MapView: View {
    
    public struct Route {
        var origin: CLLocationCoordinate2D
        var stops: [CLLocationCoordinate2D]
        var destination: CLLocationCoordinate2D
        var polyline: MKPolyline
        var stopInfo: StopMarker.StopInfo?
        
        public init(
            origin: CLLocationCoordinate2D,
            stops: [CLLocationCoordinate2D],
            destination: CLLocationCoordinate2D,
            polyline: MKPolyline,
            stopInfo: StopMarker.StopInfo?
        ) {
            self.origin = origin
            self.stops = stops.dropFirst().dropLast()
            self.destination = destination
            self.polyline = polyline
            self.stopInfo = stopInfo
        }
    }

  @Binding
  var camera: MapCameraPosition
    var route: Route?

  public init(
    camera: Binding<MapCameraPosition>,
    route: Route?
  ) {
    self._camera = camera
    self.route = route
  }

  public var body: some View {
    Map(position: $camera) {
      UserAnnotation()
        // MARK: Selected Route Line
        if let route {
            MapPolyline(route.polyline)
                .stroke(.blue, lineWidth: 5)
            
            Annotation(
            "Origen",
            coordinate: route.origin
            ) {
                OriginMarker()
            }
            
            Annotation(
            "Destino",
            coordinate: route.destination
            ) {
                DestinationMarker()
            }
            
            // MARK: Selected Route Stops
            ForEach(Array(zip(route.stops.indices, route.stops)), id: \.0) { index, stop in
                Annotation(
                "Parada \(index+1)",
                coordinate: stop
                ) {
                    StopMarker(stopInfo: route.stopInfo)
                }
            }
            
            
        }
    }
      // MARK: Map Controls
    .mapControls {
      MapUserLocationButton()
    }
    // MARK: Map View Style
    .mapStyle(.standard(elevation: .realistic))
  }
}

//#Preview {
//    MapView()
//}
