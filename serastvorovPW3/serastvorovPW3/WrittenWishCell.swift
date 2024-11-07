//
//  WrittenWishCell.swift
//  serastvorovPW2
//
//  Created by Сергей Растворов on 11/6/24.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    static let reuseId: String = "WrittenWishCell"
    
    private enum Constants {
        static let wrapColor: UIColor = .systemBackground
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 8
        static let wrapOffsetH: CGFloat = 16
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let wishLabelOffset: CGFloat = 10
        static let wishLabelFontSize: CGFloat = 16
        static let wishLabelColor: UIColor = .label
    }
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.wishLabelFontSize, weight: .medium)
        label.textColor = Constants.wishLabelColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
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
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.shadowColor = UIColor.black.cgColor
        wrap.layer.shadowOpacity = Constants.shadowOpacity
        wrap.layer.shadowRadius = Constants.shadowRadius
        wrap.layer.shadowOffset = Constants.shadowOffset
        wrap.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(wrap)
        wrap.addSubview(wishLabel)
        
        // Constraints for wrap view
        wrap.pinVertical(to: self, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: self, Constants.wrapOffsetH)
        
        // Constraints for wish label inside the wrap view
        wishLabel.pin(to: wrap, Constants.wishLabelOffset)
    }
}
