//
//  BaseCoordinator.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation

public protocol BaseCoordinatorProtocol {
    func start(animated: Bool)
    func coordinate(to coordinator: BaseCoordinatorProtocol, animated: Bool)
}

extension BaseCoordinatorProtocol {
    public func coordinate(to coordinator: BaseCoordinatorProtocol, animated: Bool = true) {
        coordinator.start(animated: animated)
    }
}
