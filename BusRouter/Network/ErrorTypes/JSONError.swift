//
//  JSONError.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation

enum JSONError: LocalizedError {
  case DECODING_ERROR(Error)
  case ENCODING_ERROR(Error)
}
