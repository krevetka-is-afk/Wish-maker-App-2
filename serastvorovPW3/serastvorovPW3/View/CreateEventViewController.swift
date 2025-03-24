//
//  CreateEventViewController.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 3/24/25.
//

import UIKit
import EventKit

final class CreateEventViewController: UIViewController {
    enum Constants {
        static let title = "Schedule Wish"
        static let buttonHeight: CGFloat = 44
        static let buttonRadius: CGFloat = 20
        static let stackSpacing: CGFloat = 16
        static let padding: CGFloat = 20
        static let cornerRadius: CGFloat = 12
    }
    
    // MARK: - Properties
    private let eventStore = EKEventStore()
    private let viewModel: WishViewModel
    private var selectedWish: WishEventModel?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let wishPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Event Title"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let descriptionTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Event Description"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Event", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.buttonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: WishViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        requestCalendarAccess()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constants.title
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(wishPicker)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(descriptionTextField)
        stackView.addArrangedSubview(startDatePicker)
        stackView.addArrangedSubview(endDatePicker)
        stackView.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            createButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
        
        wishPicker.delegate = self
        wishPicker.dataSource = self
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.onWishesUpdate = { [weak self] in
            self?.wishPicker.reloadAllComponents()
        }
    }
    
    private func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            if granted {
                print("Calendar access granted")
            } else if let error = error {
                print("Calendar access error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func createButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "Error", message: "Please enter an event title")
            return
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.notes = descriptionTextField.text
        event.startDate = startDatePicker.date
        event.endDate = endDatePicker.date
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            dismiss(animated: true)
        } catch {
            showAlert(title: "Error", message: "Failed to save event: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource
extension CreateEventViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getWishes().count
    }
}

// MARK: - UIPickerViewDelegate
extension CreateEventViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let wish = viewModel.getWishes()[row]
        return wish.title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWish = viewModel.getWishes()[row]
        titleTextField.text = selectedWish?.title
        descriptionTextField.text = selectedWish?.description
    }
} 
