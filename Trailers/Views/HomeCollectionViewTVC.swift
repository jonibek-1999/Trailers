//
//  HomeCollectionViewTVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/07/22.
//

import UIKit

protocol HomeCollectionViewTVCDelegate: AnyObject {
    func homeCollectionViewTVCdidTapCell(_ cell: HomeCollectionViewTVC, viewModel: PreviewVM)
}

final class HomeCollectionViewTVC: UITableViewCell {
    
    weak var delegate: HomeCollectionViewTVCDelegate?
    
    static let identifier = "HomeCollectionViewTableViewCell"
    private var collectionView: UICollectionView!
    private var model = [Element]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.mainColor
        configureCollectionView()
    }
    
    // MARK: - Layout & Constraints
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        
        let layoutCollectionView = UICollectionViewFlowLayout()
        layoutCollectionView.scrollDirection = .horizontal
        layoutCollectionView.itemSize = CGSize(width: 140, height: 200)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutCollectionView)
        collectionView.register(ImageCVC.self, forCellWithReuseIdentifier: ImageCVC.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
    }
    
    func configureCellWith(model: [Element]) {
        
        self.model = model
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }

}

// MARK: - CollectionView Delegate & DataSource

extension HomeCollectionViewTVC: UICollectionViewDelegate,
                                       UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.identifier, for: indexPath) as? ImageCVC else { return UICollectionViewCell() }
        item.configureImageWith(model: model[indexPath.row].poster_path ?? "")
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = model[indexPath.row]
        Vibration.soft.vibrate()
        NetworkManager.shared.getMovieVideo(withId: index.id) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    if !videoElement.isEmpty {
                        let model = PreviewVM(id: index.id, videoKeyId: videoElement[0].key, title: index.original_name ?? index.original_title ?? "Unknown", overViewText: index.overview ?? "Unknown Text", model: index)
                        guard let anotherSelf = self else {return}
                        self?.delegate?.homeCollectionViewTVCdidTapCell(anotherSelf, viewModel: model)
                    } else {
                        NetworkManager.shared.getYouTubeTrailer(withQuery: "\(index.original_name ?? index.original_title ?? "") trailer") { result in
                            switch result {
                            case .success(let videoItem):
                                let model = PreviewVM(id: index.id,videoKeyId: videoItem.id.videoId, title: index.original_name ?? index.original_title ?? "Unknown", overViewText: index.overview ?? "Unknown Text", model: index)
                                guard let anotherSelf = self else {return}
                                self?.delegate?.homeCollectionViewTVCdidTapCell(anotherSelf, viewModel: model)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


