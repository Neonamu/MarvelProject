//
//  MainCoordinator.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import UIKit

public final class MainCoordinator: BaseCoordinatorProtocol {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    public func start(animated: Bool = true) {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let startCoordinator = StartCoordinator(navigationController: navigationController)
        coordinate(to: startCoordinator, animated: animated)
    }
}
