//
//  DetailScreenViewController.swift
//  Digid
//
//  Created by Artem Kutasevych on 19.10.2023.
//

import UIKit

class DetailScreenViewController: UIViewController {
    var viewModel: DetailScreenViewModelProtocol?
    private var spinner = UIActivityIndicatorView(style: .medium)
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var text: UILabel!
    @IBOutlet private weak var confidence: UILabel!
    @IBOutlet private weak var idText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail Screen"
        showActivityIndicator()
        viewModel?.showImage(completion: { image in
            DispatchQueue.main.async {
                self.image?.image = image
                self.hideActivityIndicator()
            }
        })
        text.text = "Text: " + (viewModel?.model.text ?? "")
        confidence.text = "Confidence: " + String(viewModel?.model.confidence ?? 0)
        idText.text = "ID: " +  (viewModel?.model.id ?? "")
    }
    
    private func showActivityIndicator() {
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func hideActivityIndicator() {
        spinner.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}
