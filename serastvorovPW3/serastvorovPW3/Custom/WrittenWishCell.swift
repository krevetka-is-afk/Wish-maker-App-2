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
        static let dateLabelFontSize: CGFloat = 14
        static let dateLabelColor: UIColor = .gray
        static let dateLabelSpacing: CGFloat = 5
        static let dateLabelBottomOffset: CGFloat = 8
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
    
    // Date labels are now internal (default access level)
    let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.dateLabelFontSize)
        label.textColor = Constants.dateLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.dateLabelFontSize)
        label.textColor = Constants.dateLabelColor
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
    
    func configure(with wish: WishEventModel) {
        wishLabel.text = wish.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        startDateLabel.text = "Start: \(formatter.string(from: wish.startDate))"
        endDateLabel.text = "End: \(formatter.string(from: wish.endDate))"
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
        wrap.addSubview(startDateLabel)
        wrap.addSubview(endDateLabel)
        
        // Constraints for wrap view
        wrap.pinVertical(to: self, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: self, Constants.wrapOffsetH)
        
        // Constraints for wish label inside the wrap view
        wishLabel.pinTop(to: wrap, Constants.wishLabelOffset)
        wishLabel.pinLeft(to: wrap, Constants.wishLabelOffset)
        wishLabel.pinRight(to: wrap, Constants.wishLabelOffset)
        
        // Constraints for date labels
        startDateLabel.pinBottom(to: wrap, Constants.dateLabelBottomOffset)
        startDateLabel.pinLeft(to: wrap, Constants.wishLabelOffset)
        
        endDateLabel.pinBottom(to: wrap, Constants.dateLabelBottomOffset)
        endDateLabel.pinRight(to: wrap, Constants.wishLabelOffset)
        
        // Add spacing between wish label and date labels
        wishLabel.pinBottom(to: startDateLabel.topAnchor, Constants.dateLabelSpacing)
    }
}
