//
//  RouteCell.swift
//  BusRouter
//
//  Created by Juan Colilla on 24/12/23.
//

import SwiftUI

struct RouteCell: View {
  var description: String
  var body: some View {
    Text(description)
      .padding()
  }
}

#Preview {
  RouteCell(description: "Barcelona a Sant cugat")
    .previewLayout(.sizeThatFits)
}
