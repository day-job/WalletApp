//
//  OnboardingViewController.swift
//  wallet
//
//  Created by Pietro Basso on 14/02/2019.
//  Copyright (c) 2019 Pietro Basso. All rights reserved.
//
//  This file was generated by the Lisca Xcode Templates so
//  you can apply lisca architecture to your iOS projects
//

import UIKit
import RxSwift
import RxCocoa

protocol OnboardingViewControllerInput {
    var title: Driver<String> { get }
    var mainImage: Driver<UIImage?> { get }
    var description: Driver<String> { get }
    var buttonTitle: Driver<String> { get }
}

protocol OnboardingViewControllerOutput {
    var action: AnyObserver<OnboardingAction> { get }
}

enum OnboardingAction {
    case viewLoaded
    case buttonTapped
}

class OnboardingViewController: UIViewController {
    
    let input: OnboardingViewControllerInput
    let output: OnboardingViewControllerOutput
    private let disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        label.textColor = Theme.current().mainColor
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.current().secondaryColor
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        button.layer.cornerRadius = Theme.current().buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(input: OnboardingViewControllerInput, output: OnboardingViewControllerOutput) {
        self.input = input
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addSubviews()
        setupBindings()
        output.action.onNext(.viewLoaded)
    }

    private func setupAppearance() {
        view.backgroundColor = Theme.current().backgroundColor
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(mainImageView)
        stackView.addArrangedSubview(descriptionLabel)
        
        mainImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(continueButton)
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: Theme.current().buttonHeight).isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -30).isActive = true
    }
    
    private func setupBindings() {
        input.title.asObservable()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        input.mainImage.asObservable()
            .bind(to: mainImageView.rx.image)
            .disposed(by: disposeBag)
        input.description.asObservable()
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        input.buttonTitle.asObservable()
            .bind(to: continueButton.rx.title())
            .disposed(by: disposeBag)
        continueButton.rx.tap
            .asSignal()
            .debounce(0.2)
            .emit(onNext: { [weak self] _ in
                self?.output.action.onNext(.buttonTapped)
            })
            .disposed(by: disposeBag)
    }
}
