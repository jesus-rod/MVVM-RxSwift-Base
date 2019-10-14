//
//  UserSession.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation

public class UserSession: Codable {
    // MARK: - Properties

    public let profile: UserProfile
    public let remoteSession: RemoteUserSession

    // MARK: - Methods

    public init(profile: UserProfile, remoteSession: RemoteUserSession) {
        self.profile = profile
        self.remoteSession = remoteSession
    }
}

extension UserSession: Equatable {
    public static func == (lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.profile == rhs.profile &&
            lhs.remoteSession == rhs.remoteSession
    }
}
