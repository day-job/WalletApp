//
//  CardViewController.swift
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

protocol CardViewControllerInput {
    var title: Driver<String> { get }
    var snapshotImage: Driver<UIImage?> { get }
    var dismissSnapshot: Driver<Void> { get }
}

protocol CardViewControllerOutput {
    var action: AnyObserver<CardAction> { get }
}

enum CardAction {
    case viewLoaded
    case dismissButtonTapped
    case presentingCompleted
}

class CardViewController: UIViewController {
    
    let input: CardViewControllerInput
    let output: CardViewControllerOutput
    private let disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var snapshotImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var backgroundOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Dismiss", attributes: [.foregroundColor: UIColor.Wallet.red,
                                                                                     .font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)]), for: .normal)
        button.layer.cornerRadius = Theme.current().buttonCornerRadius
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var snapshotWidthConstraint: NSLayoutConstraint?
    private var snapshotHeightConstraint: NSLayoutConstraint?
    private var snapshotCenterYConstraint: NSLayoutConstraint?
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    
    // MARK: - Lifecycle
    
    init(input: CardViewControllerInput, output: CardViewControllerOutput) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSnapshot(presenting: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    private func setupAppearance() {
        view.backgroundColor = .black
    }
    
    private func addSubviews() {
        view.addSubview(snapshotImageView)
        snapshotWidthConstraint = snapshotImageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        snapshotHeightConstraint = snapshotImageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        snapshotCenterYConstraint = snapshotImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        snapshotImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        snapshotWidthConstraint?.isActive = true
        snapshotHeightConstraint?.isActive = true
        snapshotCenterYConstraint?.isActive = true
        
        view.addSubview(backgroundOverlayView)
        backgroundOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: Theme.current().buttonHeight).isActive = true
    }
    
    private func setupBindings() {
        input.title.asObservable()
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        input.snapshotImage.asObservable()
            .bind(to: snapshotImageView.rx.image)
            .disposed(by: disposeBag)
        input.dismissSnapshot.asObservable()
            .bind(to: rx.dismissSnapshot)
            .disposed(by: disposeBag)
        dismissButton.rx.tap
            .asSignal()
            .debounce(0.2)
            .emit(onNext: { [weak self] _ in
                self?.output.action.onNext(.dismissButtonTapped)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSnapshot(presenting: Bool) {
        let aspectRatio = (snapshotImageView.frame.size.height / snapshotImageView.frame.size.width)
        snapshotHeightConstraint?.constant = presenting ? aspectRatio * -40 : 0
        snapshotWidthConstraint?.constant = presenting ? -40 : 0
        snapshotCenterYConstraint?.constant = presenting ? -2 : 0
        statusBarStyle = presenting ? .lightContent : .default
    }
    
    fileprivate func animateSnapshot(presenting: Bool) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.backgroundOverlayView.alpha = presenting ? 0.3 : 0
        }
        UIView.animate(withDuration: presenting ? 0.3 : 0.6,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: presenting ? .curveEaseOut : .curveEaseIn,
                       animations: { [weak self] in
            self?.snapshotImageView.layer.cornerRadius = presenting ? Theme.current().buttonCornerRadius : 0
        }, completion: nil)
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: presenting ? .curveEaseOut : .curveEaseIn,
                       animations: { [weak self] in
            self?.configureSnapshot(presenting: presenting)
            self?.setNeedsStatusBarAppearanceUpdate()
            self?.view.layoutIfNeeded()
        }) { [weak self] (finished) in
            if !presenting {
                self?.output.action.onNext(.presentingCompleted)
            }
        }
    }
}

extension Reactive where Base: CardViewController {
    var dismissSnapshot: Binder<Void> {
        return Binder(base) { (viewController, _) in
            viewController.animateSnapshot(presenting: false)
        }
    }
}