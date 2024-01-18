//
//  Pet.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/16.
//

import Foundation

struct PetImage {
    let id: String
    let imageURL: URL
}

extension PetImage {
    init(response: ImagesResponse) throws {
        let id = response.id
        guard let imageURL = URL(string: response.url) else {
            throw ProcessingError.data(response.id)
        }
        self.id = id
        self.imageURL = imageURL
    }
}

struct PetName {
    let id: Int
    let name: String
}

extension PetName {
    init(response: NamesResponse) throws {
        let id = response.id
        let name = response.name
        self.id = id
        self.name = name
    }
}
