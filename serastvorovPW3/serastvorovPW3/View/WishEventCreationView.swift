//
//  WishEventCreationView.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 9/12/24.
//
import UIKit

class WishEventCreationView: UIViewController {
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        titleField.placeholder = "Enter wish title"
        descriptionField.placeholder = "Enter wish description"
        startDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date
    }
}
