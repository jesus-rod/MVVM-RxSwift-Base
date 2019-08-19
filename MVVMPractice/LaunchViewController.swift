//
//  LaunchViewController.swift
//  MVVMPractice
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import UIKit
import AppUIKit
import SampleKit
import RxCocoa
import RxSwift

class LaunchViewController: NiblessViewController {

    let viewModel: LaunchViewModel
    let disposeBag = DisposeBag()

    init(launchViewModelFactory: LaunchViewModelFactory) {
        self.viewModel = launchViewModelFactory.makeLaunchViewModel()
        super.init()
    }
    public override func loadView() {
        view = LaunchRootView(viewModel: viewModel)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
    }

    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                self.present(errorMessage: errorMessage,
                                   withPresentationState: self.viewModel.errorPresentation)
            })
            .disposed(by: disposeBag)
    }
}

protocol LaunchViewModelFactory {

    func makeLaunchViewModel() -> LaunchViewModel
}

