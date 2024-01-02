//
//  MainViewSnapshotTests.swift
//  BusRouterTests
//
//  Created by Juan Colilla on 2/1/24.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

@testable import BusRouter

final class MainViewSnapshotTests: XCTestCase {

  var view: MainView!
  var store: StoreOf<MainReducer>!

  override func setUpWithError() throws {

    store = StoreOf<MainReducer>(initialState: MainReducer.State()) {
      MainReducer()
    }
    view = MainView(store: store)

    isRecording = false
  }

  // This test ensures the MainView Screen onAppear appearance is not broken during development.
  func test_OnFirstAppear_Appearance() throws {
    store.send(.onAppear)
    assertSnapshot(of: UIHostingController(rootView: view), as: .image(on: .iPhone12))
  }
}
