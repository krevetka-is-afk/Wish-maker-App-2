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
    }
    
    private let table = UITableView(frame: .zero)
    private var wishArray: [String] = ["I wish to add cells to the table"]
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureTable()
        loadWishes()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .red
        table.dataSource = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.pin(to: view, Constants.tableOffset)
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
    }

    
    private func saveWishes() {
        defaults.set(wishArray, forKey: "wishes")
    }

    private func loadWishes() {
        if let savedWishes = defaults.array(forKey: "wishes") as? [String] {
            wishArray = savedWishes
        }
    }

}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : wishArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "AddWishCell")
            cell.textLabel?.text = "Add a new wish..."
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath)
            guard let wishCell = cell as? WrittenWishCell else { return cell }
            wishCell.configure(with: wishArray[indexPath.row])
            return wishCell
        }
    }

}

