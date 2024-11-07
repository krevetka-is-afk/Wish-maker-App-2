//
//  WrittenWishCell.swift
//  serastvorovPW2
//
//  Created by Сергей Растворов on 11/6/24.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    static let reuseId: String = "WrittenWishCell"
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        let wrap = UIView()
        wrap.backgroundColor = .white
        wrap.layer.cornerRadius = 16
        addSubview(wrap)
        wrap.addSubview(wishLabel)
        
        wrap.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            wrap.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            wrap.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            wrap.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            wishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: 8),
            wishLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: 8),
            wishLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -8),
            wishLabel.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -8)
        ])
    }
}
