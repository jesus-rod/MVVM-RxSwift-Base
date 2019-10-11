//
//  WelcomeRootView.swift
//  MVVMPractice
//
//  Created by Jesus Rodriguez on 11.10.19.
//  Copyright © 2019 com.jesusrod. All rights reserved.
//

import UIKit
import AppUIKit
import SampleKit

public class WelcomeRootView: NiblessView {

  // MARK: - Properties
  let viewModel: WelcomeViewModel
  var hierarchyNotReady = true

  let appLogoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "sloth")
    imageView.backgroundColor = Color.background
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  let appNameLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 36)
    label.text = "MVVM Practice"
    label.textColor = UIColor.white
    return label
  }()

  let signInButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Sign In", for: .normal)
    button.backgroundColor = Color.darkButtonBackground
    button.layer.cornerRadius = 3
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)
    button.heightAnchor
      .constraint(equalToConstant: 50)
      .isActive = true
    return button
  }()

  let signUpButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = Color.background
    button.layer.cornerRadius = 3
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.white.cgColor
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)
    button.heightAnchor
      .constraint(equalToConstant: 50)
      .isActive = true
    return button
  }()

  lazy var buttonStackView: UIStackView = {
    let stackView =
      UIStackView(arrangedSubviews: [signInButton, signUpButton])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = 10
    return stackView
  }()

  // MARK: - Methods
  init(frame: CGRect = .zero,
       viewModel: WelcomeViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
  }

  public override func didMoveToWindow() {
    super.didMoveToWindow()
    guard hierarchyNotReady else {
      return
    }
    backgroundColor = Color.background
    constructHierarchy()
    activateConstraints()

    signInButton.addTarget(viewModel,
                           action: #selector(WelcomeViewModel.showSignInView),
                           for: .touchUpInside)
    signUpButton.addTarget(viewModel,
                           action: #selector(WelcomeViewModel.showSignUpView),
                           for: .touchUpInside)
    hierarchyNotReady = false
  }

  func constructHierarchy() {
    addSubview(appLogoImageView)
    addSubview(appNameLabel)
    addSubview(buttonStackView)
  }

  func activateConstraints() {
    activateConstraintsAppLogo()
    activateConstraintsAppNameLabel()
    activateConstraintsButtons()
  }

  func activateConstraintsAppLogo() {
    appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    let centerY = appLogoImageView.centerYAnchor
      .constraint(equalTo: centerYAnchor)
    let centerX = appLogoImageView.centerXAnchor
      .constraint(equalTo: centerXAnchor)
    let height = appLogoImageView.heightAnchor.constraint(equalToConstant: 300)
    let width = appLogoImageView.widthAnchor.constraint(equalToConstant: 300)
    NSLayoutConstraint.activate([centerY, centerX, height, width])
  }

  func activateConstraintsAppNameLabel() {
    appNameLabel.translatesAutoresizingMaskIntoConstraints = false
    let centerX = appNameLabel.centerXAnchor
      .constraint(equalTo: appLogoImageView.centerXAnchor)
    let top = appNameLabel.topAnchor
      .constraint(equalTo: appLogoImageView.bottomAnchor, constant: 10)
    NSLayoutConstraint.activate([centerX, top])
  }

  func activateConstraintsButtons() {
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    let leading = buttonStackView.leadingAnchor
      .constraint(equalTo: layoutMarginsGuide.leadingAnchor)
    let trailing = buttonStackView.trailingAnchor
      .constraint(equalTo: layoutMarginsGuide.trailingAnchor)
    let bottom = safeAreaLayoutGuide.bottomAnchor
      .constraint(equalTo: buttonStackView.bottomAnchor, constant: 30)
    let height = buttonStackView.heightAnchor
      .constraint(equalToConstant: 50)
    NSLayoutConstraint.activate([leading, trailing, bottom, height])
  }
}

