//
//  NetworkManager.swift
//  Networking
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import Foundation

public enum NetworkManagerError: Error {
    case invalidURL
    case managerIsNil
    case nilResponse
    case errorDecodingJson
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
public class NetworkManager {
    // MARK: - Properties
    private let queue = DispatchQueue(label: "com.nico.mano.pokedex.network-manager",
                                      attributes: .concurrent)
    
    let baseURL: String

    // MARK: - Initializers
    public init(baseURL: String) {
        self.baseURL = baseURL
    }

    // MARK: - Public methods
    public func sendRequest<D: Decodable>(route: Routable, decodeTo: D.Type) async throws -> D {
        guard var baseURL = URL(string: self.baseURL) else {
            throw NetworkManagerError.invalidURL
        }

        baseURL.appendPathComponent(route.path)

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkManagerError.invalidURL
        }

        components.queryItems = route.queryItems

        guard let endpointURL = components.url else {
            throw NetworkManagerError.invalidURL
        }

        var request = URLRequest(url: endpointURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = route.httpMethod.rawValue

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(D.self, from: data)

        return result
    }
}
