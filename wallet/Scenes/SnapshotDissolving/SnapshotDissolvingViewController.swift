//
//  SnapshotDissolvingViewController.swift
//  wallet
//
//  Created by Pietro Basso on 20/02/2019.
//  Copyright (c) 2019 Pietro Basso. All rights reserved.
//
//  This file was generated by the Lisca Xcode Templates so
//  you can apply lisca architecture to your iOS projects
//

import UIKit
import RxSwift
import RxCocoa

class SnapshotDissolvingViewController: UIViewController {
    var completion: ((Bool) -> ())?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.current().statusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let snapshotView = presentingViewController?.view.snapshotView(afterScreenUpdates: true) else { return }
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(snapshotView, at: 0)
        snapshotView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        snapshotView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        snapshotView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        snapshotView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.transitionCrossDissolve],
                       animations: { [weak self] in
                        snapshotView.alpha = 0
                        self?.setNeedsStatusBarAppearanceUpdate()
        }, completion: completion)
    }
    
    func addSnapshot(at index: Int) {
        guard let snapshotView = presentingViewController?.view.snapshotView(afterScreenUpdates: true) else { return }
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(snapshotView, at: index)
        snapshotView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        snapshotView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        snapshotView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        snapshotView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}