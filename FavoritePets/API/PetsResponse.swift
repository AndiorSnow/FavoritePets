//
//  PetsResponse.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/16.
//

import Foundation

struct ImagesResponse: Decodable {
    let id: String
    let url: String
}

struct NamesResponse: Decodable {
    let id: Int
    let name: String
}
