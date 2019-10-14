//
//  NavigationAction.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation

public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {
    case present(view: ViewModelType)
    case presented(view: ViewModelType)
}
