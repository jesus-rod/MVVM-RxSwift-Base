//
//  SignUpViewModel.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

public class SignUpViewModel {

  // MARK: - Properties
  let userSessionRepository: UserSessionRepository
  let signedInResponder: SignedInResponder

  // MARK: - Methods
  public init(userSessionRepository: UserSessionRepository,
              signedInResponder: SignedInResponder) {
    self.userSessionRepository = userSessionRepository
    self.signedInResponder = signedInResponder
  }

  public let nameInput = BehaviorSubject<String>(value: "")
  public let nicknameInput = BehaviorSubject<String>(value: "")
  public let emailInput = BehaviorSubject<String>(value: "")
  public let mobileNumberInput = BehaviorSubject<String>(value: "")
  public let passwordInput = BehaviorSubject<Secret>(value: "")

  public var errorMessages: Observable<ErrorMessage> {
    return errorMessagesSubject.asObservable()
  }
  public let errorMessagesSubject = PublishSubject<ErrorMessage>()

  @objc
  public func signUp() {
    let (name, nickname, email, mobileNumber, password) = getFieldValues()
    let newAccount = NewAccount(fullName: name,
                                nickname: nickname,
                                email: email,
                                mobileNumber: mobileNumber,
                                password: password)
    userSessionRepository.signUp(newAccount: newAccount)
      .done(signedInResponder.signedIn(to:))
      .catch(handleSignUpError)
  }

  func getFieldValues() -> (String, String, String, String, Secret) {
    do {
      let name = try nameInput.value()
      let nickname = try nicknameInput.value()
      let email = try emailInput.value()
      let mobileNumber = try mobileNumberInput.value()
      let password = try passwordInput.value()
      return (name, nickname, email, mobileNumber, password)
    } catch {
      fatalError("Error accessing field values from sign up screen.")
    }
  }

  func handleSignUpError(_ error: Error) {
    errorMessagesSubject.onNext(ErrorMessage(title: "Sign Up Failed",
                                             message: "Could not sign up.\nPlease try again."))
  }
}

