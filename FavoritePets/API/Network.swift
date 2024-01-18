//
//  Network.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/16.
//

import Foundation

class Network {
    let session = URLSession(configuration: .default)
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func request<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, PetsError>) -> Void) {
        session.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async{
                if let error = error {
                    completion(.failure(.networking(error)))
                    return
                }
                guard let data = data, let strongSelf = self else {
                    completion(.failure(.noData))
                    return
                }
           
                do {
                    let decoded = try strongSelf.decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decoding(error)))
                    return
                }
            }
        }
        .resume()
    }
}
