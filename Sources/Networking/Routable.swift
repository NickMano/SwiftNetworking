//
//  Routable.swift
//  Networking
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import Foundation

public protocol Routable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: HttpMethod { get }
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
