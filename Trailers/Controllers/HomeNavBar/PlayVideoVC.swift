//
//  PlayVideoVC.swift
//  Netflix Clone
//
//  Created by ithink on 12/09/22.
//

import UIKit
import WebKit

final class PlayVideoVC: UIViewController {
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.becomeFirstResponder()
        configureNavBar()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        navigationController?.navigationBar.backgroundColor = Color.secondaryColor
        navigationController?.navigationBar.tintColor = Color.buttonColor
        let titleLabel = UILabel()
        titleLabel.text = "Trending Movie"
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = Color.buttonColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonTapped))
    }
    
    public func configureViewWith(videoElement: String?) {
        guard let videoKey = videoElement else {return}
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoKey)") else {return}
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - @objc Functions
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Layout & Constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
        
}
