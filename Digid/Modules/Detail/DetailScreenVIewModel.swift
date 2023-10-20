//
//  DetailScreenVIewModel.swift
//  Digid
//
//  Created by Artem Kutasevych on 19.10.2023.
//

import Foundation
import UIKit

protocol DetailScreenViewModelProtocol {
    var model: Item { get }
    func showImage(completion: @escaping (UIImage?) -> ())
}

final class DetailScreenViewModel: DetailScreenViewModelProtocol {
    private (set) var model: Item
    private let networkService: NetworkService
    
    init(networkService: NetworkService, model: Item) {
        self.networkService = networkService
        self.model = model
    }
    
    func showImage(completion: @escaping (UIImage?) -> ()) {
        networkService.getImageUsingURL(model.imageUrl) { image in
            completion(image)
        }
    }
}
