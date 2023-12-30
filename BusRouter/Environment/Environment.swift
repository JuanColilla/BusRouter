//
//  Environment.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation
import SwiftUI
import os.log

var Current: Environment = Live()

protocol Environment {
    var apiClient: APIClient { get set }
    var locationManager: LocationManager { get set }
    var logger: Logger { get set }
}

extension Environment {
    
    var colorScheme: ColorScheme {
        return UITraitCollection.current.userInterfaceStyle == .light ? .light : .dark
    }
    
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
