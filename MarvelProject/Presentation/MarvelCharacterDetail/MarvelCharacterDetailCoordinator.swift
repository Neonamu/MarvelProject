//
//  MarvelCharacterDetailCoordinator.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import UIKit

protocol MarvelCharacterDetailCoordinatorProtocol: AnyObject {
    func dismiss()
}

final class MarvelCharacterDetailCoordinator: BaseCoordinator, MarvelCharacterDetailCoordinatorProtocol {
    let navigationController: UINavigationController
    let identifier: Int

    init(navigationController: UINavigationController, characterId: Int) {
        self.navigationController = navigationController
        identifier = characterId
    }

    public func start(animated: Bool = true) {
        let environment = MarvelEnvironment()
        let networkService = AsyncAwaitNetworkService(environment: environment)
        let repository = MarvelDataRepository(networkService: networkService)
        let useCase = MarvelCharacterDetailUseCase(marvelRepository: repository)

        let viewModel = MarvelCharacterDetailViewModel(characterDetailUseCase: useCase, identifier: identifier)
        let detailViewController = MarvelCharacterDetailViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(detailViewController, animated: animated)
    }

    public func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
