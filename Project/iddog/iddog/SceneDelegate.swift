//
//  SceneDelegate.swift
//  iddog
//
//  Created by fellipe caetano on 10/08/20.
//  Copyright © 2020 Fellipe Caetano. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = SignInViewController()
        window?.makeKeyAndVisible()
    }
}

