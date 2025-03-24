//
//  EditWishViewController.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 3/24/25.
//

import UIKit

final class EditWishViewController: UIViewController {
    enum Constants {
        static let title = "Edit Wish"
        static let padding: CGFloat = 20
        static let textFieldHeight: CGFloat = 44
        static let buttonHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - Properties
    private let viewModel: WishViewModel
    private let wish: WishEventModel
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Wish Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Wish Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: WishViewModel, wish: WishEventModel) {
        self.viewModel = viewModel
        self.wish = wish
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constants.title
        
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(saveButton)
        
        // Configure text fields with keyboard handling
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        
        // Add "Done" button to keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        
        titleTextField.inputAccessoryView = toolbar
        descriptionTextField.inputAccessoryView = toolbar
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constants.padding),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            descriptionTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            
            startDatePicker.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: Constants.padding),
            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            startDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            
            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: Constants.padding),
            endDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            endDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func configureData() {
        titleTextField.text = wish.title
        descriptionTextField.text = wish.description
        startDatePicker.date = wish.startDate
        endDatePicker.date = wish.endDate
    }
    
    // MARK: - Actions
    @objc private func saveButtonTapped() {
        let updatedWish = WishEventModel(
            id: wish.id,
            title: titleTextField.text ?? "",
            description: descriptionTextField.text ?? "",
            startDate: startDatePicker.date,
            endDate: endDatePicker.date
        )
        
        viewModel.updateWish(updatedWish)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension EditWishViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            descriptionTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
} 
