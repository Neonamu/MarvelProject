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

final class MarvelCharacterListCoordinator: BaseCoordinator, MarvelCharacterListCoordinatorProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = true) {
        let environment = MarvelEnvironment()
       	let networkService = AsyncAwaitNetworkService(environment: environment)
       	let repository = MarvelDataRepository(networkService: networkService)
       	let useCase = MarvelCharacterListUseCase(marvelRepository: repository)

       	let viewModel = MarvelCharacterListViewModel(charactersUseCase: useCase)
        let startViewController = MarvelCharacterListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(startViewController, animated: animated)
    }

    // MARK: - Flow Methods
    public func coordinateToCharacterDetail(identifier: Int) {
        let detailCoordinator = MarvelCharacterDetailCoordinator(
            navigationController: navigationController, characterId: identifier)
        coordinate(to: detailCoordinator, animated: true)
    }
}
