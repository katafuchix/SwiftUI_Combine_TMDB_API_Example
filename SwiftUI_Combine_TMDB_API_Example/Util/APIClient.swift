//
//  APIClient.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import Foundation
import Combine

struct APIClient {

    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .mapError { error -> Error in
                                  return error
                              }
            .eraseToAnyPublisher()
    }
}

enum MovieDB {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://api.themoviedb.org/3/")!
}

enum APIPath: String {
    case trendingMoviesWeekly = "trending/movie/week"
    case searchPath = "search/movie"
}

extension MovieDB {

    static func request(_ path: APIPath) -> AnyPublisher<MovieResponse, Error> {
        guard var components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [URLQueryItem(name: "api_key", value: "b354658bf617dc74f45964b87667ec1a")]

        let request = URLRequest(url: components.url!)

        return apiClient.run(request)
            .map(\.value)
            .mapError { error -> Error in
                                  return error
                              }
            .eraseToAnyPublisher()
    }
    
    static func searchRequest(_ path: APIPath, _ query: String) -> AnyPublisher<MovieResponse, Error> {
        guard var components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [URLQueryItem(name: "api_key", value: "b354658bf617dc74f45964b87667ec1a"),
                                 URLQueryItem(name: "query", value: query)]

        let request = URLRequest(url: components.url!)

        return apiClient.run(request)
            .map(\.value)
            .mapError { error -> Error in
                                  return error
                              }
            .eraseToAnyPublisher()
    }
    
}
