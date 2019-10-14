//
//  WelcomeViewController.swift
//  MVVMPractice
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import AppUIKit
import SampleKit
import UIKit

public class WelcomeViewController: NiblessViewController {
    // MARK: - Properties

    let welcomeViewModelFactory: WelcomeViewModelFactory

    // MARK: - Methods

    init(welcomeViewModelFactory: WelcomeViewModelFactory) {
        self.welcomeViewModelFactory = welcomeViewModelFactory
        super.init()
    }

    public override func loadView() {
        let viewModel = welcomeViewModelFactory.makeWelcomeViewModel()
        view = WelcomeRootView(viewModel: viewModel)
    }
}

protocol WelcomeViewModelFactory {
    func makeWelcomeViewModel() -> WelcomeViewModel
}
