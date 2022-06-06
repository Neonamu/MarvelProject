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

final class MarvelCharacterDetailCoordinator: BaseCoordinatorProtocol, MarvelCharacterDetailCoordinatorProtocol {
    let navigationController: UINavigationController
    let identifier: Int

    init(navigationController: UINavigationController, characterId: Int) {
        self.navigationController = navigationController
        identifier = characterId
    }

    public func start(animated: Bool = true) {
        guard let marvelCharacterDetailtUseCase = DependencyManager.shared
            .resolve(MarvelCharacterDetailUseCase.self)
        else {
            preconditionFailure("MarvelCharacterDetailUseCase dependencies not found")
        }

        let viewModel = MarvelCharacterDetailViewModel(characterDetailUseCase: marvelCharacterDetailtUseCase, identifier: identifier)
        let detailViewController = MarvelCharacterDetailViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(detailViewController, animated: animated)
    }

    public func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
