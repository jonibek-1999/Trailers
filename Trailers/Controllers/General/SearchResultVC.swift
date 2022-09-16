//
//  SearchResultVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/09/22.
//

import UIKit

protocol SearchResultVCDelegate: AnyObject {
    func searchResultVCDidTappedCell(withModel model: PreviewVM)
}

final class SearchResultVC: UIViewController {
    
    weak var delegate: SearchResultVCDelegate?
    
    public var imagesUrls = [Element]()
    
    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 5, height: 200)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        view.backgroundColor = .blue
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCVC.self, forCellWithReuseIdentifier: ImageCVC.identifier)
        view.addSubview(collectionView)
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
}

//MARK: - CollectionView's Delegate & DataSource

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.identifier, for: indexPath) as? ImageCVC else {return UICollectionViewCell()}
        item.configureImageWith(model: imagesUrls[indexPath.row].poster_path ?? "")
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = imagesUrls[indexPath.row]
        Vibration.soft.vibrate()
        
        NetworkManager.shared.getMovieVideo(withId: index.id) { result in
            switch result {
            case .success(let videoElement):
                    if !videoElement.isEmpty {
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.searchResultVCDidTappedCell(withModel: PreviewVM(id: index.id, videoKeyId: videoElement[0].key, title: index.original_title ?? "", overViewText: index.overview ?? "", model: index))
                        }
                    } else {
                        NetworkManager.shared.getYouTubeTrailer(withQuery: "\(index.original_title ?? "") trailer") { result in
                            switch result {
                            case .success(let videoItem):
                                DispatchQueue.main.async { [weak self] in
                                    self?.delegate?.searchResultVCDidTappedCell(withModel: PreviewVM(id: index.id, videoKeyId: videoItem.id.videoId, title: index.original_title ?? "", overViewText: index.overview ?? "", model: index))
                                }
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
