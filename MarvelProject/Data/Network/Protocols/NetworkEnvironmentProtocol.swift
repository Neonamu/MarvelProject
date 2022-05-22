//
//  NetworkEnvironmentProtocol.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation

public protocol NetworkEnvironmentProtocol {
    var baseURL: String { get }
    var logMode: Bool { get }
    var serverTrust: Bool { get }
    var stubMode: Bool { get }
    var timeoutInterval: TimeInterval { get }
}
