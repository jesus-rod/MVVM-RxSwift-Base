//
//  FakeAuthRemoteAPI.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import PromiseKit

public struct FakeAuthRemoteAPI: AuthRemoteAPI {

    // MARK: - Methods
    public init() {}

    public func signIn(username: String, password: String) -> Promise<UserSession> {
        guard username == "johnny@gmail.com" && password == "password" else {
            return Promise(error: AppKitError.any)
        }
        return Promise<UserSession> { seal in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let profile = UserProfile(name: "Johnny Appleseed",
                                          email: "johnny@gmail.com",
                                          mobileNumber: "510-736-8754",
                                          avatar: makeURL())
                let remoteUserSession = RemoteUserSession(token: "64652626")
                let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
                seal.fulfill(userSession)
            }
        }
    }

    public func signUp(account: NewAccount) -> Promise<UserSession> {
        let profile = UserProfile(name: account.fullName,
                                  email: account.email,
                                  mobileNumber: account.mobileNumber,
                                  avatar: makeURL())
        let remoteUserSession = RemoteUserSession(token: "984270985")
        let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
        return .value(userSession)
    }
}
