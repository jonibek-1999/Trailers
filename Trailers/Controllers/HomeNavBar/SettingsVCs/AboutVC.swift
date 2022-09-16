//
//  AboutVC.swift
//  Trailers
//
//  Created by ithink on 15/09/22.
//

import UIKit

class AboutVC: UIViewController {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let appLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailers"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "ver. 1.0 - 09/2022"
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Developed by\nJonibek Bekmuratov"
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.addSubview(imageView)
        view.addSubview(appLabel)
        view.addSubview(versionLabel)
        view.addSubview(aboutLabel)
        configureNavBar()
    }
    
    // MARK: - Functions
    
    private func configureNavBar() {
        navigationItem.title = "About us"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .label
    }

    // MARK: - Layouts & Constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = view.frame.width
        
        let imageViewConstraints = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: frame / 3),
            imageView.heightAnchor.constraint(equalToConstant: frame / 3)
        ]
        
        let appLabelConstraints = [
            appLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            appLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            appLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let versionLabelConstraints = [
            versionLabel.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 5),
            versionLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            versionLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let aboutLabelConstraints = [
            aboutLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 100),
            aboutLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            aboutLabel.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(appLabelConstraints)
        NSLayoutConstraint.activate(versionLabelConstraints)
        NSLayoutConstraint.activate(aboutLabelConstraints)
    }

}
