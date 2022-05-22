//
//  BaseCoordinator.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation

public protocol BaseCoordinator {
    func start(animated: Bool)
    func coordinate(to coordinator: BaseCoordinator, animated: Bool)
}

extension BaseCoordinator {
    public func coordinate(to coordinator: BaseCoordinator, animated: Bool = true) {
        coordinator.start(animated: animated)
    }
}
