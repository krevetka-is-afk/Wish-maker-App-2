//
//  WishCalendarViewController.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 3/24/25.
//

import UIKit

final class WishCalendarViewController: UIViewController {
    enum Constants {
        static let collectionViewSpacing: CGFloat = 10
        static let cellHeight: CGFloat = 100
        static let horizontalPadding: CGFloat = 20
        static let title = "Wish Calendar"
        static let buttonHeight: CGFloat = 44
        static let buttonRadius: CGFloat = 20
        static let buttonMargin: CGFloat = 20
    }
    
    // MARK: - Properties
    private let viewModel = WishViewModel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.collectionViewSpacing
        layout.minimumInteritemSpacing = Constants.collectionViewSpacing
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - Constants.horizontalPadding, height: Constants.cellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let addEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Event", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.buttonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForBackgroundColor()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        viewModel.onWishesUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        addEventButton.addTarget(self, action: #selector(addEventButtonTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = Constants.title
        configureCollection()
        configureAddEventButton()
    }
    
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.pin(to: view, Constants.horizontalPadding)
    }
    
    private func configureAddEventButton() {
        view.addSubview(addEventButton)
        addEventButton.setHeight(Constants.buttonHeight)
        addEventButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.buttonMargin)
        addEventButton.pinHorizontal(to: view, Constants.buttonMargin)
    }
    
    private func updateUIForBackgroundColor() {
        if let backgroundColor = view.backgroundColor {
            let textColor = backgroundColor.isDark ? UIColor.white : UIColor.black
            title = Constants.title
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: textColor]
            
            // Update add event button color
            if addEventButton.backgroundColor == .white {
                addEventButton.setTitleColor(.black, for: .normal)
            } else {
                addEventButton.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func addEventButtonTapped() {
        let createEventVC = CreateEventViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: createEventVC)
        present(navController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getWishes().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath) as? WishEventCell else {
            fatalError("Unable to dequeue WishEventCell")
        }
        
        let model = viewModel.getWishes()[indexPath.item]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let startDateString = formatter.string(from: model.startDate)
        let endDateString = formatter.string(from: model.endDate)
        
        cell.configure(with: model)
        cell.startDateLabel.text = startDateString
        cell.endDateLabel.text = endDateString
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WishCalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell selection if needed
    }
}
