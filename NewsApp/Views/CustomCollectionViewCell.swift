//
//  CustomCollectionViewCell.swift
//  NewsApp
//
//  Created by Franco Garza on 28/09/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    let title: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .systemBlue
        v.textAlignment = .center
        return v
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        contentView.addSubview(title)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        setupConstraints()
    }
    
    func setupConstraints(){
        // title
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

