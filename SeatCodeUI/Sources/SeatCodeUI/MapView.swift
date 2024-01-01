//
//  SwiftUIView.swift
//
//
//  Created by Juan Colilla on 1/1/24.
//

import SwiftUI
import MapKit
import CoreLocation

public struct MapView: View {
    
    @Binding
    var camera: MapCameraPosition
    
    var tripRoute: MKPolyline?
    var stops: [CLLocationCoordinate2D]?
    
    public init(
        camera: Binding<MapCameraPosition>,
        tripRoute: MKPolyline? = nil,
        stops: [CLLocationCoordinate2D]? = nil
    ) {
        self._camera = camera
        self.tripRoute = tripRoute
        self.stops = stops
    }
    
    public var body: some View {
        Map(position: $camera) {
            UserAnnotation()
            // MARK: Selected Route Line
            if let tripRoute = tripRoute {
                withAnimation(.default) {
                    MapPolyline(tripRoute)
                        .stroke(.blue, lineWidth: 5)
                }
                // MARK: Selected Route Stops
                if let stops = stops {
                    ForEach(Array(zip(stops.indices, stops)), id:\.0) { index, stop in
                        Marker(
                            "Parada \(index+1)",
                            coordinate: stop
                        )
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
