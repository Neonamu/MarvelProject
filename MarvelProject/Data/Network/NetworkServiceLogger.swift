//
//  NetworkServiceLogger.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation

public protocol NetworkServiceLoggerProtocol {
    func logResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?)
    func logRequest(_ logRequest: URLRequest)
}


public class NetworkServiceLogger: NetworkServiceLoggerProtocol {
    public init() {
        // Needs to be accessed from other modules
    }

    public func logRequest(_ request: URLRequest) {
        guard let url = request.url else { return }
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if request.httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = request.httpMethod, method != "GET", method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = request.httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        print("====cURL Request====\n\(command.joined(separator: " \\\n\t"))\n================")
    }

    public func logResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        let response = response as? HTTPURLResponse
        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        var responseLog = ""
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let statusCode = response?.statusCode {
            responseLog += "HTTP Status Code \(statusCode)\n"
        }
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        for (key, value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data {
            let bodyString = String(data: body, encoding: .utf8) ?? "Can't render body. Not utf8 encoded"
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error {
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        print("====RESPONSE====\n\(responseLog)\n================")
    }
}
