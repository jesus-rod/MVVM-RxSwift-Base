//
//  AppUserSessionRepository.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import PromiseKit

public class AppUserSessionRepository: UserSessionRepository {
    // MARK: - Properties

    let dataStore: UserSessionDataStore
    let remoteAPI: AuthRemoteAPI

    // MARK: - Methods

    public init(dataStore: UserSessionDataStore, remoteAPI: AuthRemoteAPI) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }

    public func readUserSession() -> Promise<UserSession?> {
        return dataStore.readUserSession()
    }

    public func signUp(newAccount: NewAccount) -> Promise<UserSession> {
        return remoteAPI.signUp(account: newAccount)
            .then(dataStore.save(userSession:))
    }

    public func signIn(email: String, password: String) -> Promise<UserSession> {
        return remoteAPI.signIn(username: email, password: password)
            .then(dataStore.save(userSession:))
    }

    public func signOut(userSession: UserSession) -> Promise<UserSession> {
        return dataStore.delete(userSession: userSession)
    }
}
