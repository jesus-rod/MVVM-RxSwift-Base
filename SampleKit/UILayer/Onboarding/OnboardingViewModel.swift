//
//  OnboardingViewModel.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import RxSwift

public typealias OnboardingNavigationAction = NavigationAction<OnboardingView>

public class OnboardingViewModel: GoToSignUpNavigator, GoToSignInNavigator {
    // MARK: - Properties

    public var view: Observable<OnboardingNavigationAction> { return _view.asObservable() }
    private let _view = BehaviorSubject<OnboardingNavigationAction>(value: .present(view: .welcome))

    // MARK: - Methods

    public init() {}

    public func navigateToSignUp() {
        _view.onNext(.present(view: .signup))
    }

    public func navigateToSignIn() {
        _view.onNext(.present(view: .signin))
    }

    public func uiPresented(onboardingView: OnboardingView) {
        _view.onNext(.presented(view: onboardingView))
    }
}
