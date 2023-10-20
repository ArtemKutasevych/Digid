//
//  ListViewModel.swift
//  Digid
//
//  Created by Artem Kutasevych on 17.10.2023.
//

import UIKit

protocol ListViewModelProtocol {
    var items: [Item] { get }
    var networkService: NetworkService { get }
    func showImage(for url: String, completion: @escaping (UIImage?) -> ())
    func getItems(completion: (() -> Void)?)
}

class ListViewModel: ListViewModelProtocol {
    private (set) var items = [Item]()
    private (set) var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getItems(completion: (() -> Void)?) {
        if let number = Int(items.last?.text.components(separatedBy: ".").first ?? ""),
           number == 1 {
            completion?()
            return
        }
        
        let request = ItemsRequest(maxId: items.last?.id)
        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items += items
            case .failure(let error):
                print(error)
            }
            completion?()
        }
    }
    
    func showImage(for url: String, completion: @escaping (UIImage?) -> ()) {
        networkService.getImageUsingURL(url) { image in
            completion(image)
        }
    }
}

extension ListViewModel: CancelableTask {
    func cancelTaskBy(id: String) {
        networkService.cancelTaskBy(id: id)
    }
}
