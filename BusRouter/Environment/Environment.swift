//
//  Environment.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation
import os.log

var Current: Environment = Live()

protocol Environment {
  var apiClient: APIClient { get set }
  var logger: Logger { get set }
}

extension Environment {
  var languageCode: String {
    Locale.current.languageCode!
  }
  var regionCode: String {
    Locale.current.regionCode!
  }

  var appVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
  }

  var compilationNumber: String {
    Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
  }
}
