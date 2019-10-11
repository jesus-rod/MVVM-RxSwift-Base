//
//  SignInViewModel.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import RxSwift

public class SignInViewModel {

  // MARK: - Properties
  let userSessionRepository: UserSessionRepository
  let signedInResponder: SignedInResponder

  // MARK: - Methods
  public init(userSessionRepository: UserSessionRepository,
              signedInResponder: SignedInResponder) {
    self.userSessionRepository = userSessionRepository
    self.signedInResponder = signedInResponder
  }

  public let emailInput = BehaviorSubject<String>(value: "")
  public let passwordInput = BehaviorSubject<Secret>(value: "")

  public var errorMessages: Observable<ErrorMessage> {
    return errorMessagesSubject.asObserver()
  }
  public let errorMessagesSubject = PublishSubject<ErrorMessage>()

  public let emailInputEnabled = BehaviorSubject<Bool>(value: true)
  public let passwordInputEnabled = BehaviorSubject<Bool>(value: true)
  public let signInButtonEnabled = BehaviorSubject<Bool>(value: true)
  public let signInActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)

  @objc
  public func signIn() {
    indicateSigningIn()
    let (email, password) = getEmailPassword()
    userSessionRepository.signIn(email: email, password: password)
      .done(signedInResponder.signedIn(to:))
      .catch(indicateErrorSigningIn)
  }

  func indicateSigningIn() {
    emailInputEnabled.onNext(false)
    passwordInputEnabled.onNext(false)
    signInButtonEnabled.onNext(false)
    signInActivityIndicatorAnimating.onNext(true)
  }

  func getEmailPassword() -> (String, Secret) {
    do {
      let email = try emailInput.value()
      let password = try passwordInput.value()
      return (email, password)
    } catch {
      fatalError("Error reading email and password from behavior subjects.")
    }
  }

  func indicateErrorSigningIn(_ error: Error) {
    errorMessagesSubject.onNext(ErrorMessage(title: "Sign In Failed",
                                             message: "Could not sign in.\nPlease try again."))
    emailInputEnabled.onNext(true)
    passwordInputEnabled.onNext(true)
    signInButtonEnabled.onNext(true)
    signInActivityIndicatorAnimating.onNext(false)
  }
}
