.PHONY: help

help: ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Installs all tools required for the development environment.
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install git-lfs cocoapods carthage
	sudo git-lfs install --system
	gem install bundler --user-install
	bundle install

# Certifactes and provisioning profiles
certificates: ## Downloads the latest signing certificates and provisioning profiles.
	bundle exec fastlane certificates
certificates_refresh: ## Refreshed and then downloads the latest signing certificates and provisioning profiles.
	bundle exec fastlane certificates refresh_certificates:true

# Carthage
carthage_update: ## Updates and re-builds all dependencies managed by Carthage.
	carthage update --platform ios || rm -rvf ~/Library/Caches/org.carthage.CarthageKit/binaries/Firebase** && carthage update --platform ios
carthage_bootstrap: ## Checkout and builds all dependencies managed by Carthage.
	carthage bootstrap --platform ios --cache-builds || rm -rvf ~/Library/Caches/org.carthage.CarthageKit/binaries/Firebase** && carthage bootstrap --platform ios --cache-builds

# UIElementAssets
assets_pull: ## Pull the assets for the current commit of UIElementAssets.
	git submodule update Frameworks/UIElements/Resources/Graphics
assets_update: ## Pull the latest changes of UIElementsAssets and commit to track that version.
	git submodule update --remote Frameworks/UIElements/Resources/Graphics
	git add Frameworks/UIElements/Resources/Graphics
	git commit -m 'Update UIElementsAssets reference'

# Helpers
delete_all_snapshots: ## Deletes all snapshot test results.
	find . -type d -name '__Snapshots__' | xargs rm -r
delete_merged_branches: ## Deletes merged branches.
	git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d

# Tooling
swiftlint: ## Run SwiftLint.
	tooling/swiftlint
swiftformat: ## Run SwiftFormat.
	tooling/swiftformat .
iblint: ## Run IBLint.
	tools/IBLint lint .
rswift-generate-sixt: ## Generate R.generated file for Sixt target.
	tools/rswift generate R.generated.swift
rswift-generate-mydriver: ## Generate Rgenerate file for myDriver target.
	tools/rswift generate myDriverCustomer/R.generated.swift
rswift-generate-ride: ## Generate Rgenerate file for Ride target.
	tools/rswift generate Frameworks/Ride/Sources/R.generated.swift
generate-uielements: ## Generate Assets.generated for UIElements target.
	tools/SwiftGen/bin/swiftgen config run --config Frameworks/UIElements/swiftgen.yml
generate-localization: ## Generate Strings.generated for Localization target.
	tools/SwiftGen/bin/swiftgen config run --config Frameworks/Localization/swiftgen.yml