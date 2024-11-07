//
//  WishStoringViewController.swift
//  serastvorovPW2
//
//  Created by Сергей Растворов on 11/6/24.
//

import UIKit

final class WishStoringViewController: UIViewController {
    enum Constants {
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: CGFloat = 20
        static let addWishButtonText = "Add Wish"
        static let addWishButtonHeight: CGFloat = 50
        static let buttonMargin: CGFloat = 20
        static let maxWishes = 100              // make upper bound 
    }
    
    private let table = UITableView(frame: .zero)
    private var wishArray: [String] = []
    private let defaults = UserDefaults.standard
    
    private var addWishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.addWishButtonText, for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }
    
    private func configureUI() {
        configureTable()
        configureAddWishButton()
        loadWishes()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self   // add delegate to remove wishes
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.pin(to: view, Constants.tableOffset)
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
    }
    
    private func configureAddWishButton() {
        view.addSubview(addWishButton)
        addWishButton.setHeight(Constants.addWishButtonHeight)
        addWishButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.buttonMargin)
        addWishButton.pinHorizontal(to: view, Constants.buttonMargin)
    }
    
    private func saveWishes() {
        defaults.set(wishArray, forKey: "wishes")
    }

    private func loadWishes() {
        if let savedWishes = defaults.array(forKey: "wishes") as? [String] {
            wishArray = savedWishes
        }
    }
    
    @objc private func addWishButtonTapped() {
        guard wishArray.count < Constants.maxWishes else {
            showAlert("Limit Reached", "You can only add up to \(Constants.maxWishes) wishes.")
            return
        }
        
        let newWish = "New Wish #\(wishArray.count + 1)"
        wishArray.append(newWish)
        saveWishes()
        table.reloadData()
    }

    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension WishStoringViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath)
        guard let wishCell = cell as? WrittenWishCell else { return cell }
        wishCell.configure(with: wishArray[indexPath.row])
        return wishCell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            wishArray.remove(at: indexPath.row)
            saveWishes()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
