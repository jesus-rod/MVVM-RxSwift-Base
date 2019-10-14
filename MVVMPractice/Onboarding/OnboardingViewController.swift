//
//  Onboarding.swift
//  MVVMPractice
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import AppUIKit
import PromiseKit
import RxSwift
import SampleKit
import UIKit

public class OnboardingViewController: NiblessNavigationController {
    // MARK: - Properties

    // View Model
    let viewModel: OnboardingViewModel
    let disposeBag = DisposeBag()

    // Child View Controllers
    let welcomeViewController: WelcomeViewController
    let signInViewController: SignInViewController
    let signUpViewController: SignUpViewController

    // MARK: - Methods

    init(viewModel: OnboardingViewModel,
         welcomeViewController: WelcomeViewController,
         signInViewController: SignInViewController,
         signUpViewController: SignUpViewController) {
        self.viewModel = viewModel
        self.welcomeViewController = welcomeViewController
        self.signInViewController = signInViewController
        self.signUpViewController = signUpViewController
        super.init()
        delegate = self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribe(to: viewModel.view)
    }

    func subscribe(to observable: Observable<OnboardingNavigationAction>) {
        observable
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] action in
                guard let strongSelf = self else { return }
                strongSelf.respond(to: action)
            }).disposed(by: disposeBag)
    }

    func respond(to navigationAction: OnboardingNavigationAction) {
        switch navigationAction {
        case let .present(view):
            present(view: view)
        case .presented:
            break
        }
    }

    func present(view: OnboardingView) {
        switch view {
        case .welcome:
            presentWelcome()
        case .signin:
            presentSignIn()
        case .signup:
            presentSignUp()
        }
    }

    func presentWelcome() {
        pushViewController(welcomeViewController, animated: false)
    }

    func presentSignIn() {
        pushViewController(signInViewController, animated: true)
    }

    func presentSignUp() {
        pushViewController(signUpViewController, animated: true)
    }
}

// MARK: - Navigation Bar Presentation

extension OnboardingViewController {
    func hideOrShowNavigationBarIfNeeded(for view: OnboardingView, animated: Bool) {
        if view.hidesNavigationBar() {
            hideNavigationBar(animated: animated)
        } else {
            showNavigationBar(animated: animated)
        }
    }

    func hideNavigationBar(animated: Bool) {
        if animated {
            transitionCoordinator?.animate(alongsideTransition: { _ in
                self.setNavigationBarHidden(true, animated: animated)
            })
        } else {
            setNavigationBarHidden(true, animated: false)
        }
    }

    func showNavigationBar(animated: Bool) {
        if isNavigationBarHidden {
            setNavigationBarHidden(false, animated: animated)
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension OnboardingViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController,
                                     animated: Bool) {
        guard let viewToBeShown = onboardingView(associatedWith: viewController) else { return }
        hideOrShowNavigationBarIfNeeded(for: viewToBeShown, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        guard let shownView = onboardingView(associatedWith: viewController) else { return }
        viewModel.uiPresented(onboardingView: shownView)
    }
}

extension OnboardingViewController {
    func onboardingView(associatedWith viewController: UIViewController) -> OnboardingView? {
        switch viewController {
        case is WelcomeViewController:
            return .welcome
        case is SignInViewController:
            return .signin
        case is SignUpViewController:
            return .signup
        default:
            assertionFailure("Encountered unexpected child view controller type in OnboardingViewController")
            return nil
        }
    }
}
