//
//  UserSessionPropertyListCoder.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation

public class UserSessionPropertyListCoder: UserSessionCoding {

    // MARK: - Methods
    public init() {}

    public func encode(userSession: UserSession) -> Data {
        return try! PropertyListEncoder().encode(userSession)
    }

    public func decode(data: Data) -> UserSession {
        return try! PropertyListDecoder().decode(UserSession.self, from: data)
    }
}
