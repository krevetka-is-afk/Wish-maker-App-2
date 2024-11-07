//
//  WishMakerViewController.swift
//  serastvorovPW3
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
        
        static let constraintLeading: CGFloat = 20
        static let constraintTop: CGFloat = 10
        
        static let titleFontSize: CGFloat = 32
        static let titleText: String = "WishMaker"
        
        static let descriptionFontSize: CGFloat = 16
        static let descriptionText: String = "This app will bring you joy and will fulfill your wishes! \nThe first wish is to change the background color"
        
        static let buttonHeight: CGFloat = 44
        static let buttonBottom: CGFloat = 40
        static let buttonSide: CGFloat = 20
        static let buttonRadius: CGFloat = 20
        static let buttonText: String = "My wishes"

    }
    
    // MARK: - Properties
    private var colorModel = ColorModel(red: 0, green: 0, blue: 0)
    private let stack = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var addWishButton = UIButton(type: .system)
    private var toggleSlidersButton = UIButton(type: .system)
    private var areSlidersHidden = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
    }
    
    // MARK: - configureUI aggregate of all UI setup functions
    private func configureUI() {
        view.backgroundColor = .black
        configureTitle()
        configureDescription()
        configureAddWishButton()
        configureToggleSlidersButton()
        
        configureSliders()
        
        updateUI()
        view.layoutIfNeeded()
    }
    
    // MARK: - Update background color based on sliders
    private func updateBackgroundColor() {
        view.backgroundColor = colorModel.makeColor()
    }
    
    private func updateTextColor() {
        let invertColor = colorModel.invertedColor()
        titleLabel.textColor = invertColor
        descriptionLabel.textColor = invertColor
    }
    
    private func updateUI() {
        updateBackgroundColor()
        updateTextColor()
    }
    
    // MARK: - Configure titleLabel
    private func configureTitle() {
        titleLabel.text = Constants.titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        view.addSubview(titleLabel)
        
        titleLabel.pinCenterX(to: view)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 3 * Constants.constraintTop)
    }
    
    // MARK: - Configure descriptionLabel
    private func configureDescription() {
        descriptionLabel.text = Constants.descriptionText
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        view.addSubview(descriptionLabel)
        
        descriptionLabel.pinLeft(to: view, Constants.constraintLeading)
        descriptionLabel.pinRight(to: view, Constants.constraintLeading)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 2 * Constants.constraintTop)
    }
    
    // MARK: - Configure stack of sliders
    private func configureSliders() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layer.cornerRadius = Constants.stackRadius
        stack.clipsToBounds = true
        view.addSubview(stack)
        
        let sliderRed = createColorSlider(title: Constants.red) { [weak self] value in
            self?.colorModel.red = value
            self?.updateUI()
        }
        let sliderGreen = createColorSlider(title: Constants.green) { [weak self] value in
            self?.colorModel.green = value
            self?.updateUI()
        }
        let sliderBlue = createColorSlider(title: Constants.blue) { [weak self] value in
            self?.colorModel.blue = value
            self?.updateUI()
        }
        
        [sliderRed, sliderGreen, sliderBlue].forEach(stack.addArrangedSubview)
        

        stack.pinLeft(to: view, Constants.stackLeading)
        stack.pinRight(to: view, Constants.stackLeading)
        stack.pinBottom(to: toggleSlidersButton.topAnchor, 10)
    }


    // MARK: - Configure toggleSlidersButton
    private func configureToggleSlidersButton() {
        view.addSubview(toggleSlidersButton)
        
        toggleSlidersButton.setTitle("Hide Sliders", for: .normal)
        toggleSlidersButton.backgroundColor = .white
        toggleSlidersButton.setTitleColor(.systemPink, for: .normal)
        toggleSlidersButton.layer.cornerRadius = Constants.buttonRadius
        toggleSlidersButton.setHeight(Constants.buttonHeight)
        toggleSlidersButton.pinBottom(to: addWishButton.topAnchor, 10)
        toggleSlidersButton.pinHorizontal(to: view, Constants.buttonSide)
        
        toggleSlidersButton.addTarget(self, action: #selector(toggleSliders), for: .touchUpInside)
    }

    // MARK: - Toggle Sliders Visibility
    @objc private func toggleSliders() {
        areSlidersHidden.toggle()
        stack.isHidden = areSlidersHidden
        toggleSlidersButton.setTitle(areSlidersHidden ? "Show Sliders" : "Hide Sliders", for: .normal)
    }
    
    private func configureAddWishButton() {
        view.addSubview(addWishButton)

        addWishButton.setHeight(Constants.buttonHeight)

        addWishButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.buttonBottom)
        addWishButton.pinHorizontal(to: view, Constants.buttonSide)

        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.buttonText, for: .normal)

        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }

    
    @objc
    private func addWishButtonPressed() {
        let wishVC = WishStoringViewController()
        present(wishVC, animated: true)
    }

    
    private func createColorSlider(title: String, valueChanged: @escaping (Double) -> Void) -> CustomSlider {
        let slider = CustomSlider(title: title, min: Constants.sliderMin, max: Constants.sliderMax)
        slider.valueChanged = valueChanged
        return slider
    }
    
    // MARK: - CustomSlider
    final class CustomSlider: UIView {
        var valueChanged: ((Double) -> Void)?
        
        private let slider = UISlider()
        private let titleView = UILabel()
        
        init(title: String, min: Double, max: Double) {
            super.init(frame: .zero)
            titleView.text = title
            titleView.textColor = .black
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
            addSubview(slider)
            addSubview(titleView)
            
            titleView.pinCenterX(to: self)
            titleView.pinTop(to: topAnchor, Constants.constraintTop)
            titleView.pinLeft(to: self.leadingAnchor, Constants.constraintLeading)
            
            slider.pinTop(to: titleView.bottomAnchor)
            slider.pinCenterX(to: self)
            slider.pinLeft(to: self.leadingAnchor, Constants.constraintLeading)
            slider.pinBottom(to: bottomAnchor, Constants.constraintTop)
        }

        
        @objc
        private func sliderValueChanged() {
            valueChanged?(Double(slider.value))
        }
    }
}
