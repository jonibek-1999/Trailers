//
//  ThemePopoverVC.swift
//  Trailers
//
//  Created by ithink on 15/09/22.
//

import UIKit

class ThemePopoverVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let themes = ["Auto", "Light", "Dark"]
    private var selectedThemeNumber = Int() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedThemeNumber = UserDefaultsManager.shared.theme.rawValue
        view.backgroundColor = .separator
        configureNavBar()
        configureTableView()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        navigationItem.title = "Theme"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ThemeTVC.self, forCellReuseIdentifier: ThemeTVC.identifier)
        tableView.tintColor = Color.buttonColor
        view.addSubview(tableView)
    }
    
    //MARK: - Layout & Constarints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

//MARK: - TableView Delegate & DataSource

extension ThemePopoverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeTVC.identifier, for: indexPath) as? ThemeTVC else {return UITableViewCell()}
        cell.configureCellWith(data: themes[indexPath.row])
        
        if selectedThemeNumber == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedThemeNumber = indexPath.row
        UserDefaultsManager.shared.theme = UserDefaultsManager.Theme(rawValue: selectedThemeNumber) ?? .auto
        view.window?.overrideUserInterfaceStyle = UserDefaultsManager.shared.theme.getInterfaceStyle()
        NotificationCenter.default.post(name: NSNotification.Name("theme"), object: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        themes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
