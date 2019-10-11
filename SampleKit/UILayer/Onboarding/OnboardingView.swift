//
//  Onboardingview.swift
//  SampleKit
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import Foundation

public enum OnboardingView {

  case welcome
  case signin
  case signup

  public func hidesNavigationBar() -> Bool {
    switch self {
    case .welcome:
      return true
    default:
      return false
    }
  }
}
