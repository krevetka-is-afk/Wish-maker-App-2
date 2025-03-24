//
//  WishEventCell.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 9/12/24.
//

import UIKit

class WishEventCell: UICollectionViewCell {
    static let reuseIdentifier = "WishEventCell"

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    // Измените с private на internal (или public, если необходимо)
    public let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func configure(with model: WishEventModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        startDateLabel.text = "Start: \(model.startDate)"
        endDateLabel.text = "End: \(model.endDate)"
    }

    private func configureUI() {
        // Настроим UI для всех элементов, включая startDateLabel и endDateLabel
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(startDateLabel)
        contentView.addSubview(endDateLabel)

        // Добавьте constraints для startDateLabel и endDateLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false

        // Пример расположения элементов
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            startDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            startDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            endDateLabel.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 5),
            endDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
        ])
    }
}
