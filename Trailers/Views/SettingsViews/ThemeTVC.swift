//
//  ThemeTVC.swift
//  Trailers
//
//  Created by ithink on 15/09/22.
//

import UIKit

class ThemeTVC: UITableViewCell {
    
    static let identifier = "ThemeTVC"
    
    private let titleOfRow: UILabel = {
        let text = UILabel()
        text.textAlignment = .left
        text.font = .preferredFont(forTextStyle: .body)
        text.sizeToFit()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleOfRow)
    }
    
    public func configureCellWith(data: String) {
        titleOfRow.text = data
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleConstraints = [
            titleOfRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleOfRow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleOfRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
    
    required init(coder: NSCoder) {
        fatalError("FatalError")
    }
}
