//
//  DependencyManager.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

import Swinject

public protocol DependencyManagerProtocol {
    static var shared: DependencyManagerProtocol { get }
    func register<Dependency>(_ type: Dependency.Type, dependency: Dependency)
    func resolve<Dependency>(_ type: Dependency.Type) -> Dependency?
    func removeAllDependencies()
}

// MARK: -

public final class DependencyManager: DependencyManagerProtocol {
    public static let shared: DependencyManagerProtocol = DependencyManager()
    private let container: Container

    private init() {
        container = Container()
    }

    public func register<Dependency>(_ type: Dependency.Type, dependency: Dependency) {
        container.register(type) { _ in
            dependency
        }
    }

    public func resolve<Dependency>(_ type: Dependency.Type) -> Dependency? {
        container.resolve(type)
    }

    public func removeAllDependencies() {
        container.removeAll()
    }
}
