//
//  NameService.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/18.
//

import Foundation

protocol NameActions {
    func fetchNames(completion: @escaping (Result<[PetName], PetsError>) -> Void)
}

class NameService: NameActions {
    
    private let defaultLimit = LOAD_NUMBER
    
    private let network = Network()

    func fetchNames(completion: @escaping (Result<[PetName], PetsError>) -> Void) {
        return fetchNames(limit: defaultLimit, completion: completion)
    }
    
    func fetchNames(limit: Int, completion: @escaping (Result<[PetName], PetsError>) -> Void) {
        
        let urlString = WEBSITE + "/breeds"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "limit", value: "\(limit)")]
                                     
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL(urlString)))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(MY_API_KEY, forHTTPHeaderField: "x-api-key")
        
        network.request(request: request) { (result: Result<[NamesResponse], PetsError>) in
            switch result {
            case .success(let response):
                let pets = response.compactMap { try? PetName(response: $0) }
                completion(.success(pets))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
