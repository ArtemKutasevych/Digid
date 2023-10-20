//
//  ListViewController.swift
//  Digid
//
//  Created by Artem Kutasevych on 17.10.2023.
//
import UIKit

class ListViewController: UIViewController {
    var viewModel: ListViewModelProtocol?
    private var spinner = UIActivityIndicatorView(style: .medium)
    private var isLoading = false
    private lazy var refresher = UIRefreshControl()

    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.refreshControl = refresher
        title = "Pictures"
        showActivityIndicator()
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
    
    @objc private func loadData() {
        collectionView.refreshControl?.beginRefreshing()
        viewModel?.getItems { [weak self] in
            self?.stopRefresher()
        }
    }
    
    private func stopRefresher() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func showInformation(for item: Item) {
                if let networkService = viewModel?.networkService {
                    let viewModel = DetailScreenViewModel(networkService: networkService, model: item)
                let storyboard = UIStoryboard(name: "DetailScreenViewController", bundle: nil)
                DispatchQueue.main.async {
                    if let viewController = storyboard.instantiateInitialViewController() as? DetailScreenViewController {
                        viewController.viewModel = viewModel
                        self.hideActivityIndicator()
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCell", for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = viewModel as? CancelableTask
        let item = viewModel?.items[indexPath.item]
        cell.configure(with: item)
        cell.activityIndicator.startAnimating()
        viewModel?.showImage(for: item?.imageUrl ?? "", completion: { image in
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.imageView.image = image
            }
        })
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = viewModel?.items[indexPath.item] else { return }
        showInformation(for: item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            isLoading = true
            showActivityIndicator()
            viewModel?.getItems { [weak self] in
                guard let self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideActivityIndicator()
                }
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
}
