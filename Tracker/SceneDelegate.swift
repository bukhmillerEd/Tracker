//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Эдуард Бухмиллер on 22.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        if let isOnboardingCompleted = UserDefaults.standard.value(forKey: "isOnboardingCompleted") as? Bool,
           isOnboardingCompleted {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        }
        window?.makeKeyAndVisible()
    }
    
}

