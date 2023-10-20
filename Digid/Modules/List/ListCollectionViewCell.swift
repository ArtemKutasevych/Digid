//
//  ListCollectionViewCell.swift
//  Digid
//
//  Created by Artem Kutasevych on 17.10.2023.
//

import UIKit

protocol CancelableTask: AnyObject {
    func cancelTaskBy(id: String)
}

class ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var confidenceLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    
    var id = ""
    weak var delegate: CancelableTask?
    
    override func prepareForReuse() {
        imageView.image = nil
        delegate?.cancelTaskBy(id: self.id)
        activityIndicator.stopAnimating()
    }
    
    func configure(with item: Item?) {
        guard let item else { return }
        id = String(item.id)
        textLabel.text = item.text
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        confidenceLabel.text = String(item.confidence)
        confidenceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        idLabel.text = item.id
        idLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 5.0
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.masksToBounds = true
    }
}
