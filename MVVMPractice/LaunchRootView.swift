//
//  LaunchRootView.swift
//  MVVMPractice
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import AppUIKit
import Foundation
import SampleKit

class LaunchRootView: NiblessView {
    // MARK: - Properties

    let viewModel: LaunchViewModel

    // MARK: - Methods

    init(frame: CGRect = .zero,
         viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)

        styleView()
        loadUserSession()
    }

    private func styleView() {
        backgroundColor = Color.background
    }

    private func loadUserSession() {
        viewModel.loadUserSession()
    }
}
