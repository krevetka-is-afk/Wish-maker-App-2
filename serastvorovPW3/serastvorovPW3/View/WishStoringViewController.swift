//
//  WishStoringViewController.swift
//  serastvorovPW2
//
//  Created by Сергей Растворов on 11/6/24.
//

// WishStoringViewController.swift
import UIKit

final class WishStoringViewController: UIViewController {
    
    enum Constants {
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: CGFloat = 20
        static let addWishButtonText = "Add Wish"
        static let addWishButtonHeight: CGFloat = 50
        static let buttonMargin: CGFloat = 20
        static let datePickerHeight: CGFloat = 200
        static let datePickerOffset: CGFloat = 20
    }
    
    // MARK: - Properties
    private let viewModel = WishViewModel()
    private let table = UITableView(frame: .zero)
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private let addWishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.addWishButtonText, for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let refreshControl = UIRefreshControl()
    
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
            self?.table.reloadData()
        }
        
        viewModel.onCalendarAccessRequested = { [weak self] granted in
            if granted {
                self?.showCalendarAccessGranted()
            } else {
                self?.showCalendarAccessDenied()
            }
        }
        
        addWishButton.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        configureTable()
        configureAddWishButton()
        configureDatePicker()
        configureRefreshControl()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
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
    
    private func configureDatePicker() {
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: table.bottomAnchor, constant: Constants.datePickerOffset),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: Constants.datePickerHeight)
        ])
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshWishes), for: .valueChanged)
        table.refreshControl = refreshControl
    }
    
    private func updateUIForBackgroundColor() {
        if let backgroundColor = view.backgroundColor {
            let textColor = backgroundColor.isDark ? UIColor.white : UIColor.black
            title = "My Wishes"
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: textColor]
            
            // Update add wish button color
            if addWishButton.backgroundColor == .white {
                addWishButton.setTitleColor(.black, for: .normal)
            } else {
                addWishButton.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func addWishButtonTapped() {
        guard viewModel.canAddMoreWishes() else {
            showAlert("Limit Reached", "You can only add up to \(viewModel.getRemainingWishSlots()) more wishes.")
            return
        }
        
        let newWish = WishEventModel(
            title: "New Wish #\(viewModel.getWishes().count + 1)",
            description: "Description for wish \(viewModel.getWishes().count + 1)",
            startDate: datePicker.date,
            endDate: datePicker.date.addingTimeInterval(60 * 60 * 24)
        )
        
        viewModel.addWish(
            title: newWish.title,
            description: newWish.description,
            startDate: newWish.startDate,
            endDate: newWish.endDate
        )
    }
    
    @objc private func refreshWishes() {
        // Simulate refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showCalendarAccessGranted() {
        let alert = UIAlertController(
            title: "Wish successfully added",
            message: "You can now reveal it in your calendar.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showCalendarAccessDenied() {
        let alert = UIAlertController(
            title: "Calendar Access Denied",
            message: "Please enable calendar access in Settings to add wishes to your calendar.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func addToCalendar(_ wish: WishEventModel) {
        viewModel.requestCalendarAccess()
        viewModel.addWishToCalendar(wish) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.showEventAddedSuccess()
                } else {
                    self?.showEventAddedError()
                }
            }
        }
    }
    
    private func showEventAddedSuccess() {
        let alert = UIAlertController(
            title: "Success",
            message: "Wish has been added to your calendar.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showEventAddedError() {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to add wish to calendar. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getWishes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath)
        guard let wishCell = cell as? WrittenWishCell else { return cell }
        
        let model = viewModel.getWishes()[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let startDateString = formatter.string(from: model.startDate)
        let endDateString = formatter.string(from: model.endDate)
        
        // Отображаем отформатированные даты в ячейке
        wishCell.configure(with: model)
        wishCell.startDateLabel.text = startDateString
        wishCell.endDateLabel.text = endDateString
        
        return wishCell
    }
}

// MARK: - UITableViewDelegate
extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteWish(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let wish = viewModel.getWishes()[indexPath.row]
        let editVC = EditWishViewController(viewModel: viewModel, wish: wish)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            self?.viewModel.deleteWish(at: indexPath.row)
            completion(true)
        }
        
        let addToCalendarAction = UIContextualAction(style: .normal, title: "Add to Calendar") { [weak self] (action, view, completion) in
            let wish = self?.viewModel.getWishes()[indexPath.row]
            if let wish = wish {
                self?.addToCalendar(wish)
            }
            completion(true)
        }
        addToCalendarAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, addToCalendarAction])
    }
}
