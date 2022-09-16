//
//  SearchVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/07/22.
//

import UIKit

final class SearchVC: UIViewController {
    
    private var model = [Element]()

    private let tableView = UITableView()
    
    private let searchBarController: UISearchController = {
        let bar = UISearchController(searchResultsController: SearchResultVC())
        bar.searchBar.placeholder = "Enter a Movie name to search"
        bar.searchBar.searchBarStyle = .minimal
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigaton Bar
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchBarController
        navigationController?.navigationBar.tintColor = Color.buttonColor
        
        searchBarController.searchResultsUpdater = self
        configureTableView()
        fetchData()
    }
    
    // MARK: - Functions
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ElementTVC.self, forCellReuseIdentifier: ElementTVC.identifier)
        view.addSubview(tableView)
    }
    
    private func fetchData() {
        NetworkManager.shared.getSearchedMovies { [weak self] result in
            switch result {
            case .success(let movie):
                self?.model = movie
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Layout & Constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - TableView DataSource & Delegate

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ElementTVC.identifier, for: indexPath) as? ElementTVC else { return UITableViewCell() }
        let index = model[indexPath.row]
        cell.configureCellWith(data: TableViewVM(imageURL: index.poster_path ?? "", movieTitle: index.original_title ?? index.original_name ?? "Unknown", buttonImageName: "play.circle", dateTitle: nil))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            
        let model = model[indexPath.row]
        Vibration.soft.vibrate()
        
        NetworkManager.shared.getMovieVideo(withId: model.id) { [weak self] result in
            switch result {
            case .success(let videoElement):
                if !videoElement.isEmpty {
                    DispatchQueue.main.async {
                        let vc = PreviewVC()
                        vc.configureView(model: PreviewVM(id: model.id, videoKeyId: videoElement[0].key, title: model.original_title ?? model.original_name ?? "", overViewText: model.overview ?? "", model: model))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    NetworkManager.shared.getYouTubeTrailer(withQuery: "\(model.original_title ?? model.original_name ?? "") trailer") { result in
                        switch result {
                        case .success(let videoItem):
                            DispatchQueue.main.async {
                                let vc = PreviewVC()
                                vc.configureView(model: PreviewVM(id: model.id, videoKeyId: videoItem.id.videoId, title: model.original_name ?? model.original_title ?? "Unknown", overViewText: model.overview ?? "Unknown Overview", model: model))
                                self?.navigationController?.pushViewController(vc, animated: true)
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


// MARK: - Search Results Delegate
extension SearchVC: UISearchResultsUpdating, SearchResultVCDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultsController = searchController.searchResultsController as? SearchResultVC else {return}
        resultsController.delegate = self
        NetworkManager.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    resultsController.imagesUrls = movie
                    resultsController.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultVCDidTappedCell(withModel model: PreviewVM) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configureView(model: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
