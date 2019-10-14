//
//  MainViewModel.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import RxSwift

public class MainViewModel: SignedInResponder, NotSignedInResponder {
    // MARK: - Properties

    public var view: Observable<MainView> { return viewSubject.asObservable() }
    private let viewSubject = BehaviorSubject<MainView>(value: .launching)

    // MARK: - Methods

    public init() {}

    public func signedIn(to userSession: UserSession) {
        viewSubject.onNext(.signedIn(userSession: userSession))
    }

    public func notSignedIn() {
        viewSubject.onNext(.onboarding)
    }
}
