import XCTest
@testable import SwiftNetworking

final class NetworkManagerTests: XCTestCase {
    func testSuccessfulRequest() async throws {
        let sut = NetworkManager(baseURL: GitHubService.baseURL)
        
        let response = try await sut.sendRequest(route: GitHubService.user("NickMano"), decodeTo: GitHubUser.self)
        
        XCTAssertEqual(response.name, "NickMano")
    }
    
    func testIncorrectBaseURL() async throws {
        let url = "bad URL"
        let sut = NetworkManager(baseURL: url)
        
        do {
            _ = try await sut.sendRequest(route: GitHubService.user("NickMano"), decodeTo: GitHubUser.self)
            XCTFail("The request should fail and throw an error")
        } catch NetworkManagerError.invalidURL {
            XCTAssert(true, "The request failed because the base URL has a space")
        } catch {
            XCTFail("Unexpected error: \(error).")
        }
    }
}

struct GitHubUser: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
    }
}

enum GitHubService: Routable {
    static let baseURL = "https://api.github.com"
    
    case user(String)
    
    var path: String {
        switch self {
        case .user(let userName): return "/users/\(userName)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
}
