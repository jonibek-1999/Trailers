//
//  ImageCVC.swift
//  Netflix Clone
//
//  Created by ithink on 02/09/22.
//

import UIKit
import SDWebImage

final class ImageCVC: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    public func configureImageWith(model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Errorrrrrr")
    }
    
}
