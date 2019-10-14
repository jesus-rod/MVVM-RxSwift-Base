//
//  OnboardingDependencyContainer.swift
//  MVVMPractice
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import SampleKit
import UIKit

public class OnboardingDependencyContainer {
    // MARK: - Properties

    // From parent container
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel

    // Long-lived dependencies
    let sharedOnboardingViewModel: OnboardingViewModel

    // MARK: - Methods

    init(appDependencyContainer: MainDependencyContainer) {
        func makeOnboardingViewModel() -> OnboardingViewModel {
            return OnboardingViewModel()
        }

        sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
        sharedMainViewModel = appDependencyContainer.sharedMainViewModel

        sharedOnboardingViewModel = makeOnboardingViewModel()
    }

    // On-boarding (signed-out)
    // Factories needed to create an OnboardingViewController.
    public func makeOnboardingViewController() -> OnboardingViewController {
        let welcomeViewController = makeWelcomeViewController()
        let signInViewController = makeSignInViewController()
        let signUpViewController = makeSignUpViewController()
        return OnboardingViewController(viewModel: sharedOnboardingViewModel,
                                        welcomeViewController: welcomeViewController,
                                        signInViewController: signInViewController,
                                        signUpViewController: signUpViewController)
    }

    // Welcome
    public func makeWelcomeViewController() -> WelcomeViewController {
        return WelcomeViewController(welcomeViewModelFactory: self)
    }

    public func makeWelcomeViewModel() -> WelcomeViewModel {
        return WelcomeViewModel(goToSignUpNavigator: sharedOnboardingViewModel,
                                goToSignInNavigator: sharedOnboardingViewModel)
    }

    // Sign In
    public func makeSignInViewController() -> SignInViewController {
        return SignInViewController(viewModelFactory: self)
    }

    public func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(userSessionRepository: sharedUserSessionRepository,
                               signedInResponder: sharedMainViewModel)
    }

    // Sign Up
    public func makeSignUpViewController() -> SignUpViewController {
        return SignUpViewController(viewModelFactory: self)
    }

    public func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(userSessionRepository: sharedUserSessionRepository,
                               signedInResponder: sharedMainViewModel)
    }
}

extension OnboardingDependencyContainer: WelcomeViewModelFactory, SignInViewModelFactory, SignUpViewModelFactory {}
