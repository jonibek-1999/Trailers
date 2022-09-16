//
//  UpcomingVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/07/22.
//

import UIKit

final class UpcomingVC: UIViewController {
    
    private var model = [Element]()

    private let tableView = UITableView()
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureTableView()
        configureRefreshControl()
        fetchData()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        title = "Upcoming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = myRefreshControl
        tableView.register(ElementTVC.self, forCellReuseIdentifier: ElementTVC.identifier)
        view.addSubview(tableView)
    }
    
    private func configureRefreshControl() {
        myRefreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        myRefreshControl.tintColor = Color.lightRedColor
        myRefreshControl.attributedTitle = NSAttributedString(string: "Wait a second")
    }
    
    private func fetchData() {
        NetworkManager.shared.getUpcomingMovies { [weak self] result in
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
    
    // MARK: - @objc Functions
    
    @objc private func refreshTable(_ sender: UIRefreshControl) {
        model.shuffle()
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { [weak self] timer in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                sender.endRefreshing()
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

extension UpcomingVC: UITableViewDelegate, UITableViewDataSource {
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
