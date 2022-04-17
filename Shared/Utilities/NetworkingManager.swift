//
//  NetworkingManager.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 09.04.2022.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponce(url: URL)
        case unknow
        
        var errorDescription: String? {
            switch self {
            case .badURLResponce(let url):
                return "Bad URL Responce URL - \(url)"
            case .unknow:
                return "Unknowned error occured"
            }
        }
    }
    
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try NetworkingManager.handleURLResponce(output: $0, url: url) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponce(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let responce = output.response as? HTTPURLResponse,
              responce.statusCode >= 200 && responce.statusCode < 300 else {
            throw NetworkingError.badURLResponce(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case.finished: break
        case.failure(let error) : print(error.localizedDescription)
        }
    }
    
    
//    static func downloadWithAlamofire(url: URL) -> AnyPublisher<Data, Error> {
//        return 
//    }
}
