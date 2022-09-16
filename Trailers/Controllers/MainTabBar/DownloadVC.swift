//
//  DownloadVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/07/22.
//

import UIKit

final class DownloadVC: UIViewController {
    
    private var downloadedElements = [ElementModel]()
    
    private let downloadedTableView = UITableView()
    private let tableViewRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        // Navigaton Bar
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = editButton
        
        configureTableView()
        fetchFromDatabase()
        configureRefreshControl()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("download"), object: nil, queue: nil) { _ in
            self.fetchFromDatabase()
        }
    }
    
    // MARK: - Functions
    
    private func configureRefreshControl() {
        tableViewRefreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        tableViewRefreshControl.tintColor = Color.lightRedColor
        tableViewRefreshControl.attributedTitle = NSAttributedString(string: "Wait a second")
    }
    
    private func configureTableView() {
        downloadedTableView.refreshControl = tableViewRefreshControl
        downloadedTableView.dataSource = self
        downloadedTableView.delegate = self
        downloadedTableView.register(ElementTVC.self, forCellReuseIdentifier: ElementTVC.identifier)
        view.addSubview(downloadedTableView)
    }
    
    private func fetchFromDatabase() {
        DataPersistenceManager.shared.fetchDataFromDatabase { result in
            switch result {
            case .success(let model):
                    self.downloadedElements = model
                    self.downloadedTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - @objc Functions
    
    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {
        
        if downloadedTableView.isEditing {
            downloadedTableView.isEditing = false
            sender.title = "Edit"
            
        } else {
            downloadedTableView.isEditing = true
            sender.title = "Done"
        }
    }
    
    @objc private func refreshTable(_ sender: UIRefreshControl) {
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { [weak self] timer in
            DispatchQueue.main.async {
                self?.downloadedTableView.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    // MARK: - Layout & Constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadedTableView.frame = view.bounds
    }
}

// MARK: - TableView Delegate & DataSource

extension DownloadVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ElementTVC.identifier, for: indexPath) as? ElementTVC else {return UITableViewCell()}
        let index = downloadedElements[indexPath.row]
        cell.configureCellWith(data: TableViewVM(imageURL: index.poster_path ?? "", movieTitle: index.original_title ?? index.original_name ?? "Unknown", buttonImageName: "arrow.down.circle.fill", dateTitle: index.downloadedDate))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        downloadedElements.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteDataFromDatabase(model: downloadedElements[indexPath.row]) { result in
                switch result {
                case .success():
                    Vibration.selection.vibrate()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break;
        }
        
        downloadedElements.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .destructive, title: nil) { _, _, handler in
            DataPersistenceManager.shared.deleteDataFromDatabase(model: self.downloadedElements[indexPath.row]) { result in
                switch result {
                case .success():
                    Vibration.selection.vibrate()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            handler(true)
            self.downloadedElements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        swipeAction.backgroundColor = Color.darkRedColor
        swipeAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true;
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        downloadedElements.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}
