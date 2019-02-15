//
//  OnboardingInteractor.swift
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

protocol OnboardingInteractorDelegate: class {
    func dismissAction()
}

struct OnboardingState {
    
}

class OnboardingInteractor: OnboardingViewControllerOutput, OnboardingPresenterInput, RxStateful {
    
    typealias Action = OnboardingAction
    typealias State = OnboardingState
    typealias Dependencies = UserDefaultsServiceProvider
    
    enum Mutation {
        
    }
    
    let initialState = OnboardingState()
    let dependencies: Dependencies
    
    weak var delegate: OnboardingInteractorDelegate?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewLoaded:
            return .empty()
        case .buttonTapped:
            dependencies.userDefaultsService.set(value: true, for: .onboardingCompleted)
            delegate?.dismissAction()
            return .empty()
        }
    }
}
