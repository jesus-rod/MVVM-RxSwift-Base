//
//  UserSessionRepository.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import PromiseKit

public protocol UserSessionRepository {
    func readUserSession() -> Promise<UserSession?>
    func signUp(newAccount: NewAccount) -> Promise<UserSession>
    func signIn(email: String, password: String) -> Promise<UserSession>
    func signOut(userSession: UserSession) -> Promise<UserSession>
}
