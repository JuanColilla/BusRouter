//
//  Environment+Live.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation
import os.log

struct Live: Environment {
    //var navigator: Navigator = LiveNavigator(rootScreen: .start)
    var apiClient: APIClient = .init(baseURL: "https://sandbox-giravolta-static.s3.eu-west-1.amazonaws.com")
    var logger: Logger = .init()
}
