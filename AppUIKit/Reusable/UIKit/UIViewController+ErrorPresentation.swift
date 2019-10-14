//
//  UIViewController+ErrorPresentation.swift
//  AppUIKit
//
//  Created by Jesus Rodriguez on 16.08.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation
import RxSwift
import SampleKit
import UIKit

extension UIViewController {
    // MARK: - Methods

    public func present(errorMessage: ErrorMessage) {
        let errorAlertController = UIAlertController(title: errorMessage.title,
                                                     message: errorMessage.message,
                                                     preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }

    public func present(errorMessage: ErrorMessage,
                        withPresentationState errorPresentation: BehaviorSubject<ErrorPresentation?>) {
        errorPresentation.onNext(.presenting)
        let errorAlertController = UIAlertController(title: errorMessage.title,
                                                     message: errorMessage.message,
                                                     preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            errorPresentation.onNext(.dismissed)
            errorPresentation.onNext(nil)
        }
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }
}
