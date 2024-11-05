//
//  WishMakerViewController.swift
//  serastvorovPW2
//
//  Created by Сергей Растворов on 11/3/24.
//

import UIKit

final class WishMakerViewController: UIViewController {
    enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = -40
        static let stackLeading: CGFloat = 20
        
//        static let constraintTop: CGFloat = 30
        static let constraintLeading: CGFloat = 20
        static let constraintTop: CGFloat = 10
        
        static let titleFontSize: CGFloat = 32
        static let descriptionFontSize: CGFloat = 16
    }
    
    // MARK: - properties for color condition
    private var redValue: Double = 0
    private var greenValue: Double = 0
    private var blueValue: Double = 0
    
    // MARK: - properties for textLabels
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - configureUI agregate of all func wich work with UI
    private func configureUI() {
        view.backgroundColor = .black
        
        configureTitle()
        configureDescription()
        configureSliders()
        updateTextColor()
    }
    
    // MARK: - configureTitle modifies a titleLabel
    private func configureTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "WishMaker"
//        titleLabel.font = UIFont.systemFont(ofSize: 32)
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3 * Constants.constraintTop)
            ])
    }
    
    // MARK: - configureDescription modifies a descriptionLabel
    private func configureDescription() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "This app will bring you joy and will fulfill your wishes! \nThe first wish is to change the background color"
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.numberOfLines = 0 // allows label take couple lines
        descriptionLabel.textAlignment = .left // optional left alligment

            view.addSubview(descriptionLabel)
            NSLayoutConstraint.activate([
                descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.constraintLeading),
                descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2 * Constants.constraintTop + 2 * Constants.titleFontSize),
                descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * Constants.constraintLeading)
            ])
    }
    
    // MARK: - configureSliders creates a stack and add three sliders inside
    private func configureSliders() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        stack.layer.cornerRadius = Constants.stackRadius
        stack.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        sliderRed.valueChanged = { [weak self] value in
            self?.redValue = value
            self?.updateBackgroundColor()
        }
        
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        sliderGreen.valueChanged = { [weak self] value in
            self?.greenValue = value
            self?.updateBackgroundColor()
        }
        
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        sliderBlue.valueChanged = { [weak self] value in
            self?.blueValue = value
            self?.updateBackgroundColor()
        }
        
        for slider in [sliderRed, sliderGreen, sliderBlue, /*sliderTest*/] {
            stack.addArrangedSubview(slider)
        }
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackBottom)
        ])
        
    }
    
    // MARK: - updateBackgroundColor wrap for update a backgroundColor by values in properties
    private func updateBackgroundColor() {
        view.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        updateTextColor()
    }
    
    // MARK: - updateTextColor makes invert text color and resolve it to properties
    private func updateTextColor() {
        guard let backgroundColor = view.backgroundColor else { return }
        
        let ciColor = CIColor(color: backgroundColor)
        let invertColor = UIColor(red: 1 - 0.299 * ciColor.red, green: 1 - 0.587 * ciColor.green, blue: 1 - 0.587 * ciColor.blue, alpha: 1)
        titleLabel.textColor = invertColor
        descriptionLabel.textColor = invertColor
    }
    
    // MARK: - CustomSlider discribes a slider wich change a color of Background
    final class CustomSlider: UIView {
        var valueChanged: ((Double) -> Void)?
        
        var slider = UISlider()
        var titleView = UILabel()
        
        init(title: String, min: Double, max: Double) {
            super.init(frame: .zero)
            titleView.text = title
            slider.minimumValue = Float(min)
            slider.maximumValue = Float(max)
            slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            configureUI()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureUI() {
            backgroundColor = .white
            for view in [slider, titleView] {
                addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.constraintTop),
                titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.constraintLeading),
                
                slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                slider.centerXAnchor.constraint(equalTo: centerXAnchor),
                slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.constraintLeading),
                slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * Constants.constraintTop)
            ])
        }
        
        @objc
        private func sliderValueChanged() {
            valueChanged?(Double(slider.value))
        }
    }
}


