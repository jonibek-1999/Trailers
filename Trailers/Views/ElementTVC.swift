//
//  ElementTVC.swift
//  Netflix Clone
//
//  Created by ithink on 03/09/22.
//

import UIKit

final class ElementTVC: UITableViewCell {
    
    static let identifier = "ElementTVC"
    
    private let imageOfMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleOfMovie: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 200
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .title3)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeOfDownloadOfMovie: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.preferredMaxLayoutWidth = 200
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonOfMovie: UIButton = {
        let button = UIButton()
        button.tintColor = Color.buttonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.secondaryColor
        contentView.addSubview(imageOfMovie)
        contentView.addSubview(titleOfMovie)
        contentView.addSubview(timeOfDownloadOfMovie)
        contentView.addSubview(buttonOfMovie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureCellWith(data model: TableViewVM) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.imageURL)") else { return }
        imageOfMovie.sd_setImage(with: url, completed: nil)
        titleOfMovie.text = model.movieTitle
        let image = UIImage(systemName: model.buttonImageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        buttonOfMovie.setImage(image, for: .normal)
        guard let title = model.dateTitle else {return}
        timeOfDownloadOfMovie.text = title
    }
    
    // MARK: - Layout & Constraints

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageViewConstraints = [
            imageOfMovie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageOfMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageOfMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imageOfMovie.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleConstraints = [
            titleOfMovie.leadingAnchor.constraint(equalTo: imageOfMovie.trailingAnchor, constant: 10),
            titleOfMovie.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let timeOfDownloadConstraints = [
            timeOfDownloadOfMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            timeOfDownloadOfMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ]
        
        let buttonConstraints = [
            buttonOfMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            buttonOfMovie.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(timeOfDownloadConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
    }
}
