//
//  MainDependencyContainer.swift
//  MVVMPractice
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import RxSwift
import SampleKit
import UIKit

public class MainDependencyContainer {
    // MARK: - Properties

    // Long-lived dependencies
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel

    // MARK: - Methods

    public init() {
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserSessionDataStore()
            let remoteAPI = makeAuthRemoteAPI()
            return AppUserSessionRepository(dataStore: dataStore,
                                            remoteAPI: remoteAPI)
        }

        func makeUserSessionDataStore() -> UserSessionDataStore {
            #if USER_SESSION_DATASTORE_FILEBASED
                return FileUserSessionDataStore()

            #else
                let coder = makeUserSessionCoder()
                return KeychainUserSessionDataStore(userSessionCoder: coder)
            #endif
        }

        func makeUserSessionCoder() -> UserSessionCoding {
            return UserSessionPropertyListCoder()
        }

        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return FakeAuthRemoteAPI()
        }

        // Because `MainViewModel` is a concrete type
        //  and because `MainViewModel`'s initializer has no parameters,
        //  you don't need this inline factory method,
        //  you can also initialize the `sharedMainViewModel` property
        //  on the declaration line like this:
        //  `let sharedMainViewModel = MainViewModel()`.
        //  Which option to use is a style preference.
        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }

        sharedUserSessionRepository = makeUserSessionRepository()
        sharedMainViewModel = makeMainViewModel()
    }

    // Main
    // Factories needed to create a MainViewController.

    func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()

        // TODO: Add later
        let onboardingViewControllerFactory = {
            self.makeOnboardingViewController()
        }

//        let signedInViewControllerFactory = { (userSession: UserSession) in
//            return self.makeSignedInViewController(session: userSession)
//        }

        return MainViewController(viewModel: sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  onboardingViewControllerFactory: onboardingViewControllerFactory)
        //todo change this (uncomment and add dependencies)
//                                signedInViewControllerFactory: signedInViewControllerFactory)
    }

    // Launching

    func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(launchViewModelFactory: self)
    }

    func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(userSessionRepository: sharedUserSessionRepository,
                               notSignedInResponder: sharedMainViewModel,
                               signedInResponder: sharedMainViewModel)
    }

    // Onboarding (signed-out)
    // Factories needed to create an OnboardingViewController.

    public func makeOnboardingViewController() -> OnboardingViewController {
        let dependencyContainer = OnboardingDependencyContainer(appDependencyContainer: self)
        return dependencyContainer.makeOnboardingViewController()
    }

    // Signed-in

//    public func makeSignedInViewController(session: UserSession) -> SignedInViewController {
//        let dependencyContainer = makeSignedInDependencyContainer(session: session)
//        return dependencyContainer.makeSignedInViewController()
//    }
//
//    public func makeSignedInDependencyContainer(session: UserSession) -> KooberSignedInDependencyContainer  {
//        return KooberSignedInDependencyContainer(userSession: session, appDependencyContainer: self)
//    }
}

extension MainDependencyContainer: LaunchViewModelFactory {}
