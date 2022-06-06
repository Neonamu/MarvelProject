//
//  MarvelCharacterListCoordinator.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import UIKit

protocol MarvelCharacterListCoordinatorProtocol: AnyObject {
    func coordinateToCharacterDetail(identifier: Int)
}

final class MarvelCharacterListCoordinator: BaseCoordinatorProtocol, MarvelCharacterListCoordinatorProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = true) {
        guard let marvelCharacterListUseCase = DependencyManager.shared
            .resolve(MarvelCharacterListUseCase.self)
        else {
            preconditionFailure("MarvelCharacterListUseCase dependencies not found")
        }

        let viewModel = MarvelCharacterListViewModel(charactersUseCase: marvelCharacterListUseCase)
        let characterListViewController = MarvelCharacterListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(characterListViewController, animated: animated)
    }

    // MARK: - Flow Methods
    public func coordinateToCharacterDetail(identifier: Int) {
        let detailCoordinator = MarvelCharacterDetailCoordinator(
            navigationController: navigationController, characterId: identifier)
        coordinate(to: detailCoordinator, animated: true)
    }
}
