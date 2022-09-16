//
//  HomeVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/07/22.
//

import UIKit

enum Section: Int {
    case trendingMovies = 0
    case trendingTVs
    case popular
    case topRated
    case upcoming
}

final class HomeVC: UIViewController {
    
    private let sectionTitles = [ "Trending movies", "Trending Tv", "Popular", "Top rated", "Upcoming movies" ]
    
    private var model: Element?
    private let headerView = HomeHeaderView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let myRefreshControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.mainColor
        
        configureNavBar()
        configureTableView()
        configureRefreshControl()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: #selector(profileButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: #selector(settingButtonTapped(_:))),
            UIBarButtonItem(image: UIImage(systemName: "heart.circle"), style: .done, target: self, action: #selector(favoritesButtonTapped(_:)))
        ]
        navigationController?.navigationBar.tintColor = Color.buttonColor
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeCollectionViewTVC.self, forCellReuseIdentifier: HomeCollectionViewTVC.identifier)
        tableView.refreshControl = myRefreshControl
        tableView.sectionFooterHeight = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        createHeaderView()
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }

    private func createHeaderView() {
        
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height * 0.6))
        headerView.delegate = self
        
        DispatchQueue.main.async {
            NetworkManager.shared.getTrendingWeeklyMovies { [weak self] result in
                switch result {
                case .success(let movie):
                    let movieRandom = movie.randomElement()
                    guard let random = movieRandom else {return}
                    self?.headerView.configureHeader(withMovie: random)
                    self?.model = random
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func configureRefreshControl() {
        myRefreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        myRefreshControl.tintColor = Color.lightRedColor
        myRefreshControl.attributedTitle = NSAttributedString(string: "Wait a second")
    }
    
    // MARK: - @objc Functions
    
    @objc private func refreshTable(_ sender: UIRefreshControl) {
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { [weak self] timer in
            DispatchQueue.main.async {
                self?.createHeaderView()
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    @objc private func settingButtonTapped(_ sender: UIBarButtonItem) {
        let vc = UINavigationController(rootViewController: SettingsVC())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func favoritesButtonTapped(_ sender: UIBarButtonItem) {
        let vc = UINavigationController(rootViewController: FavoritesVC())
        present(vc, animated: true)
    }
    
    @objc private func profileButtonTapped(_ sender: UIBarButtonItem) {
        guard let model = model else {return}

        NetworkManager.shared.getMovieVideo(withId: model.id) { [weak self] result in
            switch result {
            case .success(let videoElement):
                if !videoElement.isEmpty {
                    DispatchQueue.main.async {
                        let vc = PlayVideoVC()
                        vc.configureViewWith(videoElement: videoElement[0].key)
                        self?.present(UINavigationController(rootViewController: vc), animated: true)
                    }
                } else {
                    NetworkManager.shared.getYouTubeTrailer(withQuery: "\(model.original_title ?? model.original_name ?? "") trailer") { result in
                        switch result {
                        case .success(let videoItem):
                            DispatchQueue.main.async {
                                let vc = PlayVideoVC()
                                vc.configureViewWith(videoElement: videoItem.id.videoId)
                                self?.present(UINavigationController(rootViewController: vc), animated: true)
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
    
    // MARK: - Layout & Constarints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - TableView Delegate & DataSource

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 50)))
        
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        headerLabel.textColor = .label
        headerLabel.text = sectionTitles[section]
        headerLabel.text = headerLabel.text?.capitalized
        
        headerLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        headerView.backgroundColor = Color.mainColor
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell( withIdentifier: HomeCollectionViewTVC.identifier, for: indexPath) as? HomeCollectionViewTVC
            else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Section.popular.rawValue:
            NetworkManager.shared.getPopularMovies { result in
                switch result {
                case .success(let element):
                    cell.configureCellWith(model: element)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.topRated.rawValue:
            NetworkManager.shared.getTopRatedMovies { result in
                switch result {
                case .success(let element):
                    cell.configureCellWith(model: element)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.trendingMovies.rawValue:
            NetworkManager.shared.getTrendingMovies { result in
                switch result {
                case .success(let element):
                    cell.configureCellWith(model: element)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.trendingTVs.rawValue:
            NetworkManager.shared.getTrendingTvs { result in
                switch result {
                case .success(let element):
                    cell.configureCellWith(model: element)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.upcoming.rawValue:
            NetworkManager.shared.getUpcomingMovies { result in
                switch result {
                case .success(let element):
                    cell.configureCellWith(model: element)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    // TODO: Should hide and show while scrolling the tableView
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let defaultOffset = view.safeAreaInsets.top
    //        print("view.safeAreaInsets = \(view.safeAreaInsets)")
    //        print("view.safeAreaInsets.top / defaultOffset = \(view.safeAreaInsets.top)")
    //        let customOffset = scrollView.contentOffset.y + defaultOffset
    //        print("scrollView.contentOffset = \(scrollView.contentOffset)")
    //        print("scrollView.contentOffset.y = \(scrollView.contentOffset.y)")
    //        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -customOffset))
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - Delegate Extension
extension HomeVC: HomeCollectionViewTVCDelegate, HomeHeaderViewDelegate {
    
    func homeCollectionViewTVCdidTapCell(_ cell: HomeCollectionViewTVC, viewModel: PreviewVM) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configureView(model: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func homeHeaderViewPlayButtonTapped(withModel: PreviewVM) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configureView(model: withModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
