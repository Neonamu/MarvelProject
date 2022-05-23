//
//  AppDependencies.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

enum AppDependencies {
    static func registerDependencies() {
        registerEnvironment()
        registerEndpoints()
        registerServices()
        registerRepositories()
        registerUseCases()
    }
}

// MARK: - Private

private extension AppDependencies {
    static func registerEnvironment() {
        DependencyManager.shared.register(
            NetworkEnvironmentProtocol.self,
            dependency: MarvelEnvironment()
        )

        DependencyManager.shared.register(
            NetworkServiceLoggerProtocol.self,
            dependency: NetworkServiceLogger()
        )
    }

    static func registerEndpoints() {
        DependencyManager.shared.register(
            NetworkEndpointProtocol.self,
            dependency: MarvelCharactersEndpoint()
        )

        DependencyManager.shared.register(
            MarvelCharacterDetailEndpoint.self,
            dependency: MarvelCharacterDetailEndpoint()
        )
    }

    static func registerServices() {
        guard
        	let networkEnvironment = DependencyManager.shared.resolve(NetworkEnvironmentProtocol.self),
        	let loggerService = DependencyManager.shared.resolve(NetworkServiceLoggerProtocol.self) else {
            preconditionFailure("Marvel environment not registered")
        }

        DependencyManager.shared.register(
            AsyncAwaitNetworkServiceProtocol.self,
            dependency: AsyncAwaitNetworkService(environment: networkEnvironment, logger: loggerService)
        )
    }

    static func registerRepositories() {
        guard
            let networkService = DependencyManager.shared.resolve(AsyncAwaitNetworkServiceProtocol.self)
        else {
            preconditionFailure("Services not registered")
        }

        DependencyManager.shared.register(
            MarvelDataRepository.self,
            dependency: MarvelDataRepository(networkService: networkService)
        )
    }

    static func registerUseCases() {
        guard
            let marvelDataRepository = DependencyManager.shared.resolve(MarvelDataRepository.self)
        else {
            preconditionFailure("Repositories not registered")
        }

        DependencyManager.shared.register(
            MarvelCharacterListUseCase.self,
            dependency: MarvelCharacterListUseCase(marvelRepository: marvelDataRepository)
        )

        DependencyManager.shared.register(
            MarvelCharacterDetailUseCase.self,
            dependency: MarvelCharacterDetailUseCase(marvelRepository: marvelDataRepository)
        )
    }
}
