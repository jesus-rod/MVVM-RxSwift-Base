//
//  UserSessionDataStore.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import PromiseKit

public typealias AuthToken = String

public protocol UserSessionDataStore {

    func readUserSession() -> Promise<UserSession?>
    func save(userSession: UserSession) -> Promise<(UserSession)>
    func delete(userSession: UserSession) -> Promise<(UserSession)>
}
