//
//  FavoritesVC.swift
//  Netflix Clone
//
//  Created by ithink on 09/09/22.
//

import UIKit

class FavoritesVC: UIViewController {
    
    private let tableView = UITableView()
    private var elements = [Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        configureNavBar()
        configureTableView()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        let label = UILabel()
        label.text = "Favorites"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        navigationItem.titleView = label
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = Color.buttonColor
        navigationController?.navigationBar.backgroundColor = Color.secondaryColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonTapped(_:)))
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ElementTVC.self, forCellReuseIdentifier: ElementTVC.identifier)
        view.addSubview(tableView)
    }
    
    private func fetchData() {
        let models = UserDefaultsManager.shared.fetchFavoriteMovies()
        for model in models {
            NetworkManager.shared.getElementDetails(byId: model) { [weak self] result in
                switch result {
                case .success(let element):
                    DispatchQueue.main.async {
                        self?.elements.append(element)
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }


    // MARK: - @objc Functions
    
    @objc private func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Layouts & Constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - TableView Delegate & DataSource
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ElementTVC.identifier, for: indexPath) as? ElementTVC else {return UITableViewCell()}
        let index = elements[indexPath.row]
        cell.configureCellWith(data: TableViewVM(imageURL: index.poster_path ?? "", movieTitle: index.original_title ?? index.original_name ?? "Unknown", buttonImageName: "heart.circle", dateTitle: nil))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = elements[indexPath.row]
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
