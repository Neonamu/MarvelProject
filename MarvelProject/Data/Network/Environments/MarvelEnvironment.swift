//
//  MarvelEnvironment.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation

public class MarvelEnvironment: NetworkEnvironmentProtocol {
    public var stubMode = false

    public var serverTrust = true

    public var logMode = true

    public var baseURL = "https://gateway.marvel.com"

    public var timeoutInterval: TimeInterval = 10.0
}
