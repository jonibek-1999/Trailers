//
//  SettingsTVC.swift
//  Trailers
//
//  Created by ithink on 12/09/22.
//

import UIKit

class SettingsTVC: UITableViewCell {
    
    static let identifier = "SettingsTVC"
    
    private let imageViewOfRow: UIImageView = {
        let view = UIImageView()
        view.tintColor = Color.buttonColor
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleOfRow: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = Color.darkRedColor
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imageViewOfRow)
        contentView.addSubview(titleOfRow)
        contentView.addSubview(mySwitch)
    }
    
    required init(coder: NSCoder) {
        fatalError("Fatal error")
    }
    
    // MARK: - Functions
    
    public func configureCellWith(title: String, image: String, hasSwitch: Bool) {
        imageViewOfRow.image = UIImage(systemName: image)
        titleOfRow.text = title
        mySwitch.isHidden = !hasSwitch
    }
    
    // MARK: - Layout & Constraints
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageConstraints = [
            imageViewOfRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageViewOfRow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageViewOfRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imageViewOfRow.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        let titleConstraints = [
            titleOfRow.leadingAnchor.constraint(equalTo: imageViewOfRow.trailingAnchor, constant: 15),
            titleOfRow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let switchConstraints = [
            mySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(switchConstraints)
    }

}
