//
//  SignedInResponder.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation

public protocol SignedInResponder {
    func signedIn(to userSession: UserSession)
}
