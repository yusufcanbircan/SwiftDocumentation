//
//  APICaller.swift
//  CombineUsage
//
//  Created by Yusuf Can Bircan on 8.04.2023.
//

import UIKit
import Combine

class APICaller {
    static let shared = APICaller()
    private var cancellables = Set<AnyCancellable>()
    private let baseUrl = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchCompanies() -> Future<[String], Error> {
        return Future { promixe in
            DispatchQueue.main.async {
                promixe(.success(["Apple", "Facebook", "Google", "Spotify"]))
            }
        }
    }
    
    func getData<T: Codable>(type: T.Type) -> Future<[T], Error> {
        
        return Future<[T], Error> { [weak self] promixe in
            guard let self = self,
                  let url = URL(string: baseUrl) else {
                return promixe(.failure(NetworkError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promixe(.failure(decodingError))
                        case let apiError as NetworkError:
                            promixe(.failure(apiError))
                        default:
                            promixe(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: {
                    promixe(.success($0))
                }
                .store(in: &self.cancellables)
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}
