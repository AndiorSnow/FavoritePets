//
//  PetsViewModel.swift
//  FavoritePets
//
//  Created by LMC60018 on 2024/1/16.
//

import Foundation

protocol ShowsError {
    func showError(message: String)
}

protocol PetsViewModelDelegate: AnyObject, ShowsError {
    func reloadData()
}

class PetsViewModel {

    private(set) var petImages: [PetImage] = []
    private let imageActions: ImageActions
    private(set) var petNames: [PetName] = []
    private let nameActions: NameActions
    
    weak var delegate: PetsViewModelDelegate?

    init(imageActions: any ImageActions = ImageService(), nameActions: any NameActions = NameService()) {
        self.imageActions = imageActions
        self.nameActions = nameActions
    }

    func start() {
        fetchImages()
        fetchNames()
    }
    
    func load() {
        fetchNames()
    }

    private func fetchImages() {
        typealias T = Int
        imageActions.fetchImages() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(pets):
                self.petImages = pets
                self.delegate?.reloadData()
            case let .failure(error):
                self.delegate?.showError(message: error.displayError)
            }
        }
    }
    
    private func fetchNames() {
        typealias T = Int
        nameActions.fetchNames() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(pets):
                self.petNames += pets
                self.delegate?.reloadData()
            case let .failure(error):
                self.delegate?.showError(message: error.displayError)
            }
        }
    }
}
