//
//  String+Date.swift
//  BusRouter
//
//  Created by Juan Colilla on 26/12/23.
//

import Foundation

extension String {

  func shortHour() -> String {
    // ISO 8601
    let isoFormatter = DateFormatter()
    isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    // Short Hour
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "HH:mm"

    guard let date = isoFormatter.date(from: self) else { return "N/A" }
    return outputFormatter.string(from: date)
  }
}
