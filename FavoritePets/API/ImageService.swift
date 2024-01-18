//
//  PetsService.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/16.
//

import Foundation

protocol ImageActions {
    func fetchImages(completion: @escaping (Result<[PetImage], PetsError>) -> Void)
}

class ImageService: ImageActions {
    enum ImageSize {
        case small
        case thumbnail

        var queryItem: String {
            switch self {
            case .small: return "small"
            case .thumbnail: return "thumbnail"
            }
        }
    }
    
    private let defaultLimit = TOP_TEN
    private let defaultSize: ImageSize = .thumbnail
    
    private let network = Network()

    func fetchImages(completion: @escaping (Result<[PetImage], PetsError>) -> Void) {
        return fetchImages(limit: defaultLimit, size: defaultSize, completion: completion)
    }
    
    func fetchImages(limit: Int, size: ImageSize, completion: @escaping (Result<[PetImage], PetsError>) -> Void) {
        
        let urlString = WEBSITE + "/images/search"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "limit", value: "\(limit)"),
                                     URLQueryItem(name: "size", value: size.queryItem)]
                                     
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL(urlString)))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(MY_API_KEY, forHTTPHeaderField: "x-api-key")
        
        network.request(request: request) { (result: Result<[ImagesResponse], PetsError>) in
            switch result {
            case .success(let response):
                let pets = response.compactMap { try? PetImage(response: $0) }
                completion(.success(pets))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
