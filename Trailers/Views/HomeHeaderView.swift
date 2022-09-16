//
//  HomeHeaderView.swift
//  Netflix Clone
//
//  Created by ithink on 06/07/22.
//

import UIKit

protocol HomeHeaderViewDelegate: AnyObject {
    func homeHeaderViewPlayButtonTapped(withModel: PreviewVM)
}

final class HomeHeaderView: UIView {
    
    private var model: Element!
    
    private let imageView = UIImageView()
    private let playButton = UIButton()
    private let downloadButton = UIButton()
    
    private let imageGradient = CAGradientLayer()
    weak var delegate: HomeHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        applyGradient()
        makeButton(playButton, "Play")
        makeButton(downloadButton, "Download")
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Functions
    
    public func configureHeader(withMovie model: Element) {
        self.model = model
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.poster_path ?? "")") else {return}
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    private func applyGradient() {
        imageGradient.colors = [
            Color.mainColor!.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            Color.mainColor!.cgColor
        ]
        self.layer.addSublayer(imageGradient)
    }
    
    private func makeButton(_ button: UIButton, _ name: String) {
        
        button.setTitle("\(name)", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(.systemRed, for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = Color.lightRedColor.withAlphaComponent(0.6)
        button.layer.shadowColor = UIColor.yellow.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
    }
    
    // MARK: - @objc Functions
    
    @objc private func playButtonTapped(_ sender: UIButton) {
        Vibration.light.vibrate()
        NetworkManager.shared.getMovieVideo(withId: model.id) { [weak self] result in
            guard let id = self?.model.id else {return}
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    if !videoElement.isEmpty {
                        guard let item = self?.model else {return}
                        let model = PreviewVM(id: id, videoKeyId: videoElement[0].key, title: self?.model.original_title ?? self?.model.original_name ?? "", overViewText: self?.model.overview ?? "", model: item)
                        self?.delegate?.homeHeaderViewPlayButtonTapped(withModel: model)
                    } else {
                        NetworkManager.shared.getYouTubeTrailer(withQuery: "\(self?.model.original_title ?? "") trailer") { result in
                            switch result {
                            case .success(let videoItem):
                                guard let item = self?.model else {return}
                                let model = PreviewVM(id: id, videoKeyId: videoItem.id.videoId, title: self?.model.original_title ?? self?.model.original_name ?? "", overViewText: self?.model.overview ?? "", model: item)
                                self?.delegate?.homeHeaderViewPlayButtonTapped(withModel: model)
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
    
    @objc private func downloadButtonTapped(_ sender: UIButton) {
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageGradient.frame = self.bounds
        imageView.frame = self.bounds
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -15),
            playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -70),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 15),
            downloadButton.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),
            downloadButton.widthAnchor.constraint(equalTo: playButton.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
}
