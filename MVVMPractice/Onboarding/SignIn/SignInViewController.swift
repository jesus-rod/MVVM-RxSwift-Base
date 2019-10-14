//
//  SignInViewController.swift
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

public class SignInViewController: NiblessViewController {
    // MARK: - Properties

    let disposeBag = DisposeBag()
    let viewModelFactory: SignInViewModelFactory
    let viewModel: SignInViewModel

    // MARK: - Methods

    init(viewModelFactory: SignInViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        viewModel = viewModelFactory.makeSignInViewModel()
        super.init()
    }

    public override func loadView() {
        view = SignInRootView(viewModel: viewModel)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
    }

    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                self?.present(errorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view as! SignInRootView).configureViewAfterLayout()
    }
}

protocol SignInViewModelFactory {
    func makeSignInViewModel() -> SignInViewModel
}

extension SignInViewController {
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                (view as! SignInRootView).moveContentForDismissedKeyboard()
            } else {
                (view as! SignInRootView).moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }
}
