//
//  PreviewVC.swift
//  Netflix Clone
//
//  Created by ithink on 04/09/22.
//

import UIKit
import WebKit

final class PreviewVC: UIViewController {
    
    private var model: Element!
    private var url: URL!
    private var isFavorite = false
    private var isDownloaded = false
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelMovie: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var overViewMovie: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.titleLabel?.sizeToFit()
        button.tintColor = .label
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 3.5
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = Color.lightRedColor.cgColor
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavBar()
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(webView)
        containerView.addSubview(labelMovie)
        containerView.addSubview(downloadButton)
        containerView.addSubview(overViewMovie)
        configureScrollView()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = Color.buttonColor
        isFavorite = UserDefaultsManager.shared.isFavoriteMovie(model.id)
        let imageName = isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareButtonTapped(_:))),
            UIBarButtonItem(image: UIImage(systemName: imageName), style: .done, target: self, action: #selector(heartButtonTapped(_:)))
        ]
    }
    
    private func configureScrollView() {
        scrollView.backgroundColor = .systemBackground
        containerView.backgroundColor = .systemBackground
        let contentSize = CGSize(width: view.frame.width,
                                 height: view.frame.height + overViewMovie.frame.height)
        scrollView.contentSize = contentSize
        scrollView.frame = view.bounds
        //TODO: Should fix the overLaying Download button problem
        containerView.frame.size = contentSize
    }
    
    public func configureView(model: PreviewVM) {
        self.model = model.model
        self.labelMovie.text = model.title
        self.overViewMovie.text = model.overViewText
        
        DispatchQueue.main.async { [weak self] in
            guard let url = URL(string: "https://www.youtube.com/embed/\(model.videoKeyId)") else {return}
            self?.url = url
            self?.webView.load(URLRequest(url: url))
        }
        isDownloaded = DataPersistenceManager.shared.isMovieDownloaded(model.id)
        
        if isDownloaded {
            downloadButton.backgroundColor = Color.secondaryColor
            downloadButton.isUserInteractionEnabled = false
            downloadButton.setTitle("Downloaded", for: .normal)
            
        } else {
            downloadButton.backgroundColor =  Color.darkRedColor
            downloadButton.isUserInteractionEnabled = true
            downloadButton.setTitle(" Download", for: .normal)
            downloadButton.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        }
    }
    
    // MARK: - @objc Functions
    
    @objc func heartButtonTapped(_ sender: UIBarButtonItem) {

        if isFavorite {
            UserDefaultsManager.shared.removeMovieFromFavorites(model.id)
            sender.image = UIImage(systemName: "heart")
            isFavorite = !isFavorite
        } else {
            UserDefaultsManager.shared.addMovieToFavorites(model.id)
            sender.image = UIImage(systemName: "heart.fill")
            isFavorite = !isFavorite
        }
    }
    
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc func downloadButtonTapped(_ sender: UIButton) {
        
        DataPersistenceManager.shared.download(model: model) { result in
            switch result {
            case .success():
                
                DispatchQueue.main.async {
                    sender.pulseAnimate()
                }
                Vibration.success.vibrate()
                
                NotificationCenter.default.post(name: NSNotification.Name("download"), object: nil)
            case .failure(let error):
                Vibration.error.vibrate()
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Layout & Constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let mainFrame = UIScreen.main.bounds
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: mainFrame.height / 2.5)
        ])
        
        NSLayoutConstraint.activate([
            labelMovie.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 15),
            labelMovie.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            labelMovie.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            overViewMovie.topAnchor.constraint(equalTo: labelMovie.bottomAnchor, constant: 15),
            overViewMovie.leadingAnchor.constraint(equalTo: labelMovie.leadingAnchor),
            overViewMovie.trailingAnchor.constraint(equalTo: labelMovie.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: overViewMovie.bottomAnchor, constant: 30),
            downloadButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: mainFrame.width / 3),
            downloadButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}

