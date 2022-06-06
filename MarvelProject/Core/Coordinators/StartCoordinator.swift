//
//  StartCoordinator.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import UIKit

public final class StartCoordinator: BaseCoordinatorProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = true) {
        let startCoordinator = MarvelCharacterListCoordinator(navigationController: navigationController)
        coordinate(to: startCoordinator, animated: animated)
    }
}
