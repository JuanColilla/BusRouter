//
//  SceneDelegate.swift
//  BusRouter
//
//  Created by Juan Colilla on 17/12/23.
//

import SwiftUI
import UIKit
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let mainView = MapView(
        store: StoreOf<MapReducer>(
            initialState: MapReducer.State()
        ) {
            MapReducer()
        }
    )

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UIHostingController(rootView: mainView)

    self.window = window
    window.makeKeyAndVisible()
  }
}
