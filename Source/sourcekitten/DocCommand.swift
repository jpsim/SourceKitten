//
//  DocCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct DocCommand: CommandProtocol {
    let verb = "doc"
    let function = "Print Swift or Objective-C docs as JSON"

    struct Options: OptionsProtocol {
        let spmModule: String
        let singleFile: Bool
        let moduleName: String
        let objc: Bool
        let arguments: [String]

        static func create(spmModule: String) -> (_ singleFile: Bool) -> (_ moduleName: String) -> (_ objc: Bool) -> (_ arguments: [String]) -> Options {
            return { singleFile in { moduleName in { objc in { arguments in
                self.init(spmModule: spmModule, singleFile: singleFile, moduleName: moduleName, objc: objc, arguments: arguments)
            }}}}
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "spm-module", defaultValue: "",
                                   usage: "document a Swift Package Manager module")
                <*> mode <| Option(key: "single-file", defaultValue: false,
                                   usage: "only document one file")
                <*> mode <| Option(key: "module-name", defaultValue: "",
                                   usage: "name of module to document (can't be used with `--single-file` or `--objc`)")
                <*> mode <| Option(key: "objc", defaultValue: false,
                                   usage: "document Objective-C headers")
                <*> mode <| Argument(defaultValue: [],
                                     usage: "Arguments list that passed to xcodebuild. If `-` prefixed argument exists, place ` -- ` before that.")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        let args = options.arguments
        if !options.spmModule.isEmpty {
            return runSPMModule(moduleName: options.spmModule)
        } else if options.objc {
            return runObjC(options: options, args: args)
        } else if options.singleFile {
            return runSwiftSingleFile(args: args)
        }
        let moduleName: String? = options.moduleName.isEmpty ? nil : options.moduleName
        return runSwiftModule(moduleName: moduleName, args: args)
    }

    func runSPMModule(moduleName: String) -> Result<(), SourceKittenError> {
//        let args: [String] = [
//            "-module-name",
//            "Lyft",
//            "-Onone",
//            "-DDEBUG",
//            "-D",
//            "COCOAPODS",
//            "-sdk",
//            "/Applications/Xcode-8.3.3.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.3.sdk",
//            "-target",
//            "x86_64-apple-ios8.0",
//            "-g",
//            "-module-cache-path",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/ModuleCache",
//            "-Xfrontend",
//            "-serialize-debugging-options",
//            "-enable-testing",
//            "-Xcc",
//            "-I",
//            "-Xcc",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator",
//            "-I",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator",
//            "-Xcc",
//            "-F",
//            "-Xcc",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/Instabug",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/APAddressBook",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/AmpKit",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/Appboy-iOS-SDK",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/Bolts",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/Braintree",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/Bugsnag",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/CoreAPI-iOS",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/FBSDKCoreKit",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/FBSDKLoginKit",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/JGProgressHUD",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/KSCrash",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/Kronos",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/LambdaKit-iOS",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/LyftKit-iOS",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/LyftNetworking-iOS",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/LyftUI",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/Mixpanel",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/ModelMapper-iOS",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/SDWebImage",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/SnapKit",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/Stripe-iOS",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/libPhoneNumber-iOS",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/lightstep",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/opentracing",
//            "-F",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/zipzap",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/GoogleMaps/Base/Frameworks",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/GoogleMaps/Maps/Frameworks",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/GooglePlaces/Frameworks",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/Instabug",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/TrustDefenderMobile/Frameworks",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/Tune",
//            "-F",
//            "/Users/jsimard/src/Lyft-iOS/Pods/WazeTransport/Frameworks",
//            "-c",
//            "-j8",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Helpers & Managers/PayoutDetailSectionGenerator.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/AddEmailViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/DynamicText+Settings.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverContactingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Round Up And Donate/RoundUpAndDonateCharityCells.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/DriverInfoBubbleView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/Scheduler.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Animations/InRideSummaryAnimator.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Views/ExpressPayPaymentMethodTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Split Pay/Views/SplitPayInviteEmptyStateView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Extensions/ChargeAccount+Icon.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/AnalyticsElement.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Controllers/DriverResumeApplicationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/Geocoder.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/CreditCardViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Controllers/FilteredContactsController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/AddShortcutViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/StandardInRideModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/ShortcutManager+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/RidePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/ModelObserver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/WazeDelegate.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/GeofenceDisplayComponent.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLineAcceptedModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Protocols/AmpOnboardingPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Extensions/LyftAPI+ExpressPay.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/OnlinePowerZoneCollapsedIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/SettingsEmailViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Extensions/LyftAPI+PayoutHistory.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/WalkToDropoffPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverEarningsSectionHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/SignOnStatsCardView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Location Feedback/UXAnalytics+LocationFeedbackSurvey.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverMenuActions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/NavigationApplication.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Pickup Adjustment/Controllers/PickupAdjustmentViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/AddNameAndEmailViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/OnlineTieredCollapsedIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PotentialCarPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/MapZoomAnalyticsReporter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/PriceInformationModalPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/UpfrontExpensingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/VenueSplashViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpTroubleshootingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/InRideSummaryRepresentable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Controllers/DriverEarningsExpandedIncentiveViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/AppDelegate.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Views/ReferralSectionHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/AppShortcutManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/ButtonAccessoryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Views/FocusingTextEntryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/SettingsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/PolygonPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Controllers/RideHistoryLoadingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/VenueManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Controllers/PromosViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/UXElements+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Views/ProcessingStatusView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/VenuePinExpandedView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLineNavigation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/LyftActionSheet+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/SkipDestinationButton.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/WalkToDropoffSummaryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Controllers/RideHistoryRootViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Protocols/CreditCardInputValidatable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/UIImagePickerControllerSourceType+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/LocationIngestion.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Protocols/ExpressPayUpdater.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Views/OverviewRouteViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Recommended Pickups/Controllers/RecommendedPickupsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Views/DriverScheduleItemView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Helpers & Managers/DriverOnboardingRouter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/EmailOwnershipChallengeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLineRideEnqueuedModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Controllers/AppboyInAppMessageDelegate.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Controllers/DriverScheduleErrorViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/AppLaunchViewControllerCache.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/GeofenceCirclePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Protocols/CreditCardViewDelegate.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/NSLayoutConstraint+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Controllers/PayoutHistoryListViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/APContact+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/InRideSummaryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/CCVTextField.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/FixedPriceEstimatePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Round Up And Donate/RoundUpAndDonateSectionHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Split Pay/Controllers/SplitPayInviteViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Modals/Video.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Protocols/ChargeAccountTokenizable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Controllers/RideHistoryDetailViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/QueuePinView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverRatingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpRePairSuccessfulViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Protocols/AmpAlertsAnimationPlayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Views/PayoutDateCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverRouteUpdatedModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/InstabugManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/BootstrapManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverAboutLineModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/RideStopAccessory.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Coupons Purchase/Controllers/CouponPurchaseViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/Constants.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/ExpressPayCardView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Round Up And Donate/RoundUpAndDonateMenuViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/ConfirmPickupModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/AppSwitch/ActiveDriverModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Deep Link/DeepLinkRequest.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/SchedulerTask.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/FixedRouteConfigurationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Analytics/ChargeAccountMethod+Analytics.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/ScheduleRideViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Helpers & Managers/GoogleSDK.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/DriverPaymentMethodsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Protocols/PromoErrorDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Protocols/PaymentInput.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/PhotoConfirmViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Power Zones/PowerZoneManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Extensions/RideManager+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/AnimatedMarker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Accessibility/Constants/DynamicText+Accessibility.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/FixedRouteScheduledRideModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/InRideSummaryDelegate.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/NSAttributedString+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Routers/MapStateRouter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/CreditCardTextField.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/CreditCardView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/ScheduledRideWidgetOverlayViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/BaseStateViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/FacebookChallengeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/UXElements.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/SessionInformationManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/DriverMarker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/AddressAndModeSelector.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Landing & Location/LandingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Helpers & Managers/RemoteNotificationCategory.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Inbox/Views/InboxMessageTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Helpers & Managers/AppboySDK.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Views/DriverModeSwitchView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverStatsDialView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Helpers/AmpOnboardingVideos.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Controllers/BusinessProfileEditEmailViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/AddPhoneVerifyViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverWaypointEnrouteViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/LoginChallengeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Controllers/DriverToggleController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/WidgetOptionCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/StreetViewThumbnailPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/LineInformationModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverWaypointMoveOnViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/CrossSellSliderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Views/PhoneNumberView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PickupAdjustable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/TimeRange+Formatting.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/DateAndTimeRangeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/RideModeTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/ExpirationDateTextField.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/LineContactingModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/Heartbeat.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/DynamicText+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/DateAndTimeRangeItemView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/IdleModePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/TimelineView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/PromoBannerView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/ShortcutManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/MapViewHeatmapController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Views/PayoutLineItemCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/PassengerRatingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverPickedUpModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Helpers/DialViewHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/PasteboardTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLineInRideModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Views/ScheduledRideTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/ScheduleRideConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/FixedRoute+WithinServiceHours.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/CLLocationCoordinate2D+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/ClosedRange+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/AnalyticsEvent.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Controllers/ExpressPayAlertModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Landing & Location/NotificationSettingsModal.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/StandardIdleModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/AppConfigManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/LoginViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Protocols/ContactsSelectable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideRequest+RideMode.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/URL+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/LocationManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Protocols/BitmapRepresentable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/OfflineRideCollapsedIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/RoutePassengersCollectionView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/MapLocationAndZoomButton.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/CircularProgressView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/Haptic.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Lost and Found/Protocols/LostItemActionDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/CurrentFixedRoutesPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Hourly Guarantees/HourlyGuaranteeScheduleTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/PersonalInsuranceViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/DynamicText.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/MapShape.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverStatsDetailsView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/PayPalAccountViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Helpers & Managers/PromoCodeEntryStatus.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/ContactingAnimationPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Controllers/PayoutHistoryDetailViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/HintManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/FacebookChargeAccountViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/OfflineTieredCollapsedIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Help/Extensions/LyftAPI+Help.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverNavigation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/NearbyCarsCachingFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/WebRoute.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Protocols/AmpPairingInitiator.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Helpers/LocationSharer.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Routers/BusinessProfileRouter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/SettingsViewController+Options.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/PollingConnectivityFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/UXElement+PushNotifications.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/FixedRoutePickupStopImagePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Controllers/DriverOnboardingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/GoogleAPI+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Controllers/RideWalkthroughViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/PickupAddressConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Controllers/InviteContactsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Helpers & Managers/CreditCardErrorReason.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/ProfileHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Help/Controllers/HelpArticlesViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Controllers/DriverConsentDocumentViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Power Zones/PowerZoneScheduleTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/InviteHelper+ReferralScreen.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Non Active Region/NonActiveRegionModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/BusinessProfilesOnboardingModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/VenuePinView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/CostEstimate+PrimeTime.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/SettingsPhoneViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/InRideWidgetController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Deep Link/DeepLinkManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/UXAnalytics+RideInformation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/GeofenceCircle.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/AnalyticsQATracker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Accessibility/Controllers/ProfileViewController+Accessibility.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Models/PolylineAnimations.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/ActionEvent+Referral.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/NavigationBarPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/WidgetOptionConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Inbox/Helpers & Managers/InboxCallToActionButtonFactory.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/TermsOfServiceViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PartySizeEditor.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/VenueMarkersPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/PassengerRideHistoryCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/MapStatePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/FixedRouteConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/ShadowButton.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/AddNameViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Controllers/DriverScheduleLoadingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Models/InRideMenuOption.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Helpers/AmpAnimations.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Lost and Found/Controllers/LostItemFormViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/BusinessProfileViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/ExpandedTieredIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/PaypalChargeAccountViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Views/AmpConnectedBackgroundView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/DriverDestinationIdleModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/EditPersonalInsuranceViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Views/ConsentAttachmentTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/ErrorOptionCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/DriverVenueDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Referral/DriverReferralViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/EditDebitCardViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/CostEstimate+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Helpers & Managers/LyftAPI+PaymentsHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Protocols/RideCompleter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/TrackedVariants.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/ParallaxTableViewHeader.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Views/AmpGlowingBackgroundView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Controllers/DriverScheduleListViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/CreditCodeTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/CountryTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Controllers/DriverConsoleHomeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/DriverNotification.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Calendar Integration/Controllers/CalendarAuthorizationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/HTTPRideFeedbackFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLinePickupViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Protocols/AmpOnboardingVideoPlayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/IncentiveExpandedMapMarker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/DriverExperiments.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Referral/ReferralCallToActionTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpStartRePairViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpStartPairingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/LaunchScreenView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Hourly Guarantees/HourlyGuaranteeScheduleTopTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/VehicleViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/PrimeTimeModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Animations/LineInRideAnimation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Models/DriverSummaryCard.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/Events/DriverActions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/SharingMethod+Referral.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/RideModeContacting.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/FixedRoutePendingWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/LineInRideCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpStartTutorialViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/AmpBeaconOverlayViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/DebitCardViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Views/PayoutHistoryTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/StandardContactingModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/InviteHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/MapMarker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/DynamicText+Ride.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Protocols/RateAndPayStepRepresentable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Controllers/AppboyInAppMessageModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/IncentiveMapMarker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/InstabugHTTPFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Protocols/ContactsControllerDelegate.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/Hints.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PotentialCarPoller.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Views/Transitions/FullscreenTransition.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverAcceptedModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/AppSwitch/DriverApp.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Views/ToolbarPassengersView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/AppSwitch/SwitchToDriverAppModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/ChargeCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/SpanningEvent.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Controllers/InAppMessageModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Protocols/OrganizationMembershipRepresentable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/MarkerZoomable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/PassengerExperiments.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/MapStateDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/BillCalloutCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverAutoSwitchNavigationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/EditProfilePhotoViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/DynamicPinView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/BaseDocumentViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Power Zones/PowerZoneScheduleViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Models/OnboardingContext.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/LyftRootViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/ScheduledRideAccessoryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/GoogleRouteCacheable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/CommuterBenefitsModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/TooltipView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Protocols/DriverLineRoutePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/Hackery.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/VenueDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/VenueLocationSelector.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/PrefillFetcher.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/PinBannerView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/NSUserActivity+LocationSuggestion.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Extensions/CouponChargeAccount+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Location Feedback/LocationFeedbackSurveyViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Hourly Guarantees/HourlyGuaranteeManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/BackgroundTaskFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/OnlineRideCollapsedIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/MapView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Controllers/RideHistoryListViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/QueueFullPinView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Help/Views/HelpArticleTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/CompleteProfileViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/MapBannerView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/PaymentExpenseDetailsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/InvalidCostTokenHandler.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/FixedRouteDriverETAObserver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/InRideWaypointConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Helpers & Managers/RemoteNotificationsManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/FixedRouteItineraryCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/WatchCommunication.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Recommended Pickups/Protocols/PickupRecommendable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpAlertModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Protocols/ContactsTableViewPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Controllers/DriverGoOnlineOverlayViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/AnalyticsRoute.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpSettingsOverlayViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverRideToolbarViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/SelectPaymentMethodsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Views/CalloutView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/ShippingAddressViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/SharingMethod+Lyft.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/MainActionButtonConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/InRideWidgetDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideStopAccessoryPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Deep Link/DeepLinkRequest+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Split Pay/Controllers/SplitPayRequestViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/UXElements+Passenger.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/PlaceSearcher.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Pickup Adjustment/Views/PickupAdjustmentTooltipView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/MapViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/CouponChargeAccountViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLineSkipPickupModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Views/NavigationModeView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Deep Link/PassengerUniversalLinks.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Protocols/ResponseCacheable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverEarningsSummaryCollectionViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Protocols/PaymentMethodsDataSource.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Extensions/GMSPolygon+Geometry.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PromotionHintPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpStartInstallationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Deep Link/DeepLinkManager+Analytics.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/SplitPaymentCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/PreRequestETDPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/PhotoCropViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Views/BottomRoundedCornersView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/LineRoutePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/WaypointsInfoOverlayViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverPickupTimeAddedModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/DebtViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Helpers & Managers/CouponHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/PassengerFixedRoute+Formatting.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/VehicleSelectionViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/SettingsServicesViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Helpers & Managers/NewsfeedManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/FixedRouteConfirmViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/DriverOnboardingPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Pickup Adjustment/Controllers/PickupAdjustmentInfoModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Round Up And Donate/RoundUpAndDonatePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Views/ServerTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Views/ShimmerCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Protocols/AmpAlertsObserver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/FixedRouteScheduleConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Split Pay/Views/SplitPayCoinAnimationView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/AnchoredPinContentPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/ScheduleRideModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/AnalyticsSession.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/BorderedButtonCircle.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/UXAnalytics.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Controllers/RideWalkthroughDoneModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/MapBannerPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Controllers/BusinessProfileOnboardingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/DriverCommunicator.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Protocols/OnboardingPhaseDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/WidgetOptionViews.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverArrivedViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/StoredValues+Shared.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/RideHistoryMapCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/RateAppModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/MatchedPassengerInfoView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/RideCanceler.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/Analytics.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/NotificationSettingsHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Views/Transitions/DriverAutoSwitchTransition.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/RideDescriptionRepresentable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/CollapsedIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Extensions/LyftAPIError+BusinessProfile.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/Safari+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/LineIdleModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/SettingsNavigationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Views/DriverConsoleNewsfeedHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/Date+Formatting.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Controllers/DriverEarningsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Views/RideOverviewSectionHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/PaymentHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Helpers & Managers/States.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/VenueViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/FixedRouteStopPhotoTooltipView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideRequester.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/EmailReceiptsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/EditProfileViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Protocols/DriverWaypointPinPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/ScheduledRideCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/RideModeCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/FixedRouteScheduleCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/DriverMarkersPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/PinLocationModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/FixedRouteInformationModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Extensions + Helpers/RideHistory+UIExtension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/DriverPerformanceFooterView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/VenueWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Controllers/PayoutHistoryRootViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Views/AmpAlertWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/PriceInfoViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/DriverProfileViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Controllers/ExpressPayConfirmViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/LineInRideConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/Assets.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/DriverVenueManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Landing & Location/LegalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Deep Link/PassengerDeepLinks.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/PaymentMethodTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Views/InstallNavigationAppTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Views/PassengerLocationView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/Double+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Power Zones/PowerZoneScheduleTopTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideScheduler+MapState.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Extensions/NewsfeedItemType+Comparable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/SurveyViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Controllers/BusinessProfileEmailVerifiedViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Views/VehicleSelectionTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Autonomous/Views/AutonomousSummaryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Extensions/SettingsViewController+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Views/DriverPaymentMethodsSectionHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/FixedRouteOfflineCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/FullscreenPhotoViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Protocols/DriverPricingDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Deep Link/DriverDeepLinks.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/ProhibitedVenueModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Views/PayoutExpressPayAccountCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/FixedRouteInRideModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Views/DriverScheduleDateHeader.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/LineItemCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Helpers & Managers/UserPhotoPickerHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Protocols/ScrollToFullScreenPresenting.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/Scheduler+Setup.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/ScheduledRideModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpTroubleshootingArticleViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/RideDescriptionPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/FixedRouteOutOfReachCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PassengerMenuPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLinePickedUpModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Helpers & Managers/PaypalLoginPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Helpers/AmpPackDownloader.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideMode+Equatable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/AppDelegate+FastIdleLaunch.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/RideStopCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/EventCalendar.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Controllers/CollatedContactsController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/CountrySectionHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Landing & Location/ServerListViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/LifecycleAnalytics.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/ExpandedPowerZoneIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverStandardNavigation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RouteStopTimelinePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Protocols/OnboardingPhaseAdvanceable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/PaymentMethodsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverSuspensionModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/MapObserver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/FixedRouteCrossSellable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/ScheduledRideTimes+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/AddressAndModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/Events/Action.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Referral/ReferrerStrings.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/DefaultPaymentMethodViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Controllers/ConsoleTabBarViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/SeparatorCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverEarningsIncentiveTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Analytics/OnboardingAnalytics.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/DriverVenue+Icon.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Referral/ReferralCallToActionItem.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/CancelReasonsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideModesPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Landing & Location/HelpViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Models/DateAndTimeRangeModels.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/DriverMapViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Deep Link/CommonDeepLinks.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/GlobalErrorHandlerFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/LocalNotification.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/TextViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Extensions + Helpers/ServerAction.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Views/CouponChargeAccountDetailCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Recommended Pickups/Extensions/PinMarkersPresenter+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/RideModeInRide.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/RoutePassengerViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/Timer+Duration.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/HTTPTracingFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/DriverSwappable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/AddDebitCardModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Controllers/NavigationSwitchViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/RadialGradientView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Helpers & Managers/DocumentPhotoPickerHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/DriverInQueueHeader.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Controllers/PayoutHistoryErrorViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/InviteCardView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/PaymentViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Controllers/DriverScheduleProxyViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/ShareActivityProviders.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/DriverInfoBannerView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Controllers/SettingsPhoneVerifyViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PassengerLineRoutePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/StreetViewModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/Error+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/AppRoleHandler.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Controllers/PromosTableViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Landing & Location/LocationRequestMapBackedViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/Collation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/UIButton+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Controllers/SocialSharePromptViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/RideModesCachingFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Protocols/ContactsPresentable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideModeFeature+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/InRideDestinationConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Referral/DriverReferrer.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/PinLocationSearchViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Routers/RideRequestRouter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/DottedLineView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/AudioPlayer.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Power Zones/PowerZoneDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/PlaceSearchViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/ScheduledRideTimes+DescriptiveRangeModels.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Protocols/DriverLineInfoModalPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/GradientView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/ScheduledRideAccessoryConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/DefaultPaymentMethodTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/PlaceTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/ScheduledRidesSelector.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/DebtCreditCardTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Recommended Pickups/Views/RecommendedPickupWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/Modal Controllers/DriverPrimeTimeModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Split Pay/Controllers/SplitPayFilteredContactsController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Views/PreviewCellCollectionViewFlowLayout.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverEarningsBonusCardCollectionViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/RideKind+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/DriverExpiredAlertModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Autonomous/Controllers/AutonomousOptOutViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Autonomous/Managers/AutonomousAssetManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Protocols/PhoneNumberVerifier.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/ServerActionCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Views/ReferralTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/DriverDestinationSetupViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/FixedRoutePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Helpers & Managers/DriverWebRouter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/AddressBookContact+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/RatingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverEarningsSummaryCollectionView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/Asset+RideKind.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Authentication/CountrySelectionViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Extensions/CLLocationAnnotated+CurrentState.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/ConfirmPriceModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/RideManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Extensions/SideMenuViewController+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Venues/QueueManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/ScheduledRideAccessoryOverlayViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/UXAnalytics+Localization.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/ICloudHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Views/ProfileHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Protocols/PaymentSelector.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/InstallNavigationAppModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/RecommendedContactsCollation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/PlaceSearchDataSource.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Controllers/BusinessProfileVerifyEmailViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Controllers/SocialSharePostRidePromptViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Helpers/AmpConnectionTracker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/ExperimentAnalytics.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/RideModeModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/ServerEnvironment+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/FixedRouteContactingModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideRequest+ScheduledRide.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/Modal Controllers/DriverDropoffModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/Constants+AppleWatch.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/CityPlaceSearchViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/NSUserActivity+Extension.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/IncentiveScheduleConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/ChangeRouteConfirmationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Autonomous/Protocols/AutonomousPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Controllers/CouponLocationRestrictionsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Base/OnboardingRouter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/MarkersPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Controllers/DestinationVenueViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Settings/Views/ExpensingProviderCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/RequestDeferrerMigration.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Helpers & Managers/ContactsManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Views/PassengerNavigationView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Protocols/ModalRideStatusDismissable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/ShortcutMarkersPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/BannerView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Split Pay/Controllers/SplitPayCollatedContactsController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/RideHistoryProfileCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/TieredIncentiveInfoView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Helpers/Amp.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/FloatingButton.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/ExpandedHourlyGuaranteeIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideModesConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/ProfileViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverBaseStateViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/MapZoomable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideKind+Information.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Controllers/ExpenseManagementViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/PassengerScheduledRideWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/ShortcutTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Helpers/AmpPack.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpTurnOnBluetoothViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/ExtraHTTPHeadersFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Controllers/LineInRideModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/Schedulable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/DynamicText+Variants.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Menu/Views/Transitions/SideMenuTransition.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Views/PayoutBonusLinkCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Helpers & Managers/DispatchErrorHandler.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Extensions/GMSMarker+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/HomeScreenMessagePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/DestinationConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Views/PickupDropoffCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverInRideModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Round Up And Donate/RoundUpAndDonateDetailsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Help/Models/HelpArticle.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/RideSharer.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/ScheduledRidesDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Post-Authentication/NotificationsSettingsModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideTransitionHandler.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Views/DriverScheduleSliderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/UserManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Views/VenueAccessoryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/PolylinePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/RidePayment.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Split Pay/Common/RecentContactsIndexedCollation.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Recommended Pickups/Protocols/RecommendedPickupsPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Accessibility/Views/StarsRatingControl+Accessibility.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Schedule/Controllers/DriverScheduleRootViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/PinMarkerContentPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Views/ContactsSectionHeaderView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideModeInformationModalPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideModeDelegate.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/UserCachingFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Controllers/ExpressPayConfirmAnimationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Post-Authentication/IntentionPromptViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PickupTimeExtender.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverStatsCardView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Analytics/PaymentInput+AnalyticElement.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/DriverIdleModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Controllers/BusinessProfileCarouselViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Menu/Controllers/SideMenuViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/DurationRange+Formatting.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Views/Transitions/ProfileModalTransition.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Protocols/ContactsLoadable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/VenueBannerPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideScheduler.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/AppLaunch.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Recommended Pickups/Protocols/RecommendedPickupZonePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/DriverPerformanceWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Helpers & Managers/ApplePay.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Controllers/EarningAlertsPermissionModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/PassengerIdleModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Invites and Sharing/Views/ContactTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/InRideSummaryViewModelGenerator.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/PinMarkersPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/Events/TrackedExperiments.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverLapseSignOutModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/RideIncentiveInfoView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Helpers & Managers/DriverConsoleMarkersPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/ExpandedRideIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Menu/Views/SideMenuDriveToggleView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/HTTPAnalyticsFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Driver Ads/Controllers/PostRideDriverUpsellViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Menu options/Profiles/Controllers/PhotoPickerController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideRequester+MapState.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Extensions/MenuOption+PassengerOptions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/PassengerContactingWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/StoredValues.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/WaypointConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Extensions/GMSCoordinateBounds+Geometry.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Views/StarsRatingControl.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/AvailableFixedRouteObserver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Post-Authentication/LocationsSettingsModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Protocols/FeatureHighlighter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Ride History/Controllers/RideHistoryErrorViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Coupons Purchase/Controllers/CouponProcessingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/TuneHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Protocols/DriverWaypointNotificationsPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Helpers & Managers/ScanCreditCardHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Line/Controllers/DriverLineArrivedModeViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Routers/StoryboardRouter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Protocols/ExpressPayGetPaidPresentable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Protocols/ModalControllerPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Onboarding/Controllers/DriverWelcomeFlowModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Settings/Views/PrefixedTextField.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Recommended Pickups/Protocols/RecommendedPickupZoneHintable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Views/CrossSellItemView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Views/OnlineHourlyGuaranteeCollapsedIncentiveView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/GoogleRoutePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Inbox/Controllers/InboxViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/AlertBannerPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/ThreatMetrix.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Onboarding/Controllers/Post-Authentication/RemoteNotificationsModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Protocols/Hintable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Views/PayoutSummaryHeaderCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/Events/CommonActions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Controllers/TipModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Invites and Sharing/Controllers/DriverInviteContactsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Console/Views/DriverConsoleNewsfeedCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/Events/PassengerActions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Extensions/Ride+Cancelations.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpRePairingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Protocols/DestinationVenueRequestor.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/PermissionsHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/FixedRouteScheduleRideViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Views/NavigationAppTableViewCell.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Common/Controllers/DriverMissedRequestModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/RideStopsConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Promos/Helpers & Managers/PromosTableViewDataSource.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Controllers/WebPopupModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpTutorialViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Map Common/Helpers & Managers/PlaceHelpers.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Hourly Guarantees/HourlyGuaranteeDisplayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/EditLocationAccessoryView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/AppInfoManager.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/LocationFeedbackNotification/GoogleAPI+LocationFeedback.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/CrashReporter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Rate & Pay/Views/TippingStepper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/PickupCountdownPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/Ride+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpSettingsViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Protocols/AmpPickupAnimationPlayable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/HTTPDriverRideStatusFilter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/AudioSession.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Pickup Adjustment/Views/PickupAdjustmentWidget.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Deep Link/DeepLinkToRequestRide.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Migrations/LyftTokenToOAuth2Migration.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/PhoneVerifyModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Controllers/PaymentsModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Payout History/Controllers/PayoutHistoryLoadingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/ScheduledRidePresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Extensions/UIImageView+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Controllers/ViewControllers.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Views/MatchedPassengerStopView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/UserManager+Driver.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/BusinessProfile/Controllers/BusinessProfileSignupViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Helpers & Managers/BraintreeHelper.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Protocols/EmailSuggestionPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Driver Stats + Express Pay/Views/DriverToggleView.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Payments/Views/ZIPTextField.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpPairingViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Common/Helpers & Managers/SchedulableDefinitions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Amp/Controllers/AmpNavigationController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Protocols/TableViewConfigurable.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Controllers/RideOverviewViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Ride Modes/Standard/Controllers/Modal Controllers/DriverPickupModalViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/AnalyticsTracker.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Extensions/RideRequest+Venue.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/In Ride Modes/Protocols/MatchedPassengerPresenter.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Passenger/Idle Ride Modes/Controllers/RideConfigurationViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Common/Messaging and Notifications/Helpers & Managers/RemoteNotificationsManager+NotificationActions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Analytics/CommonAttributes.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Geofence Incentives/Hourly Guarantees/HourlyGuaranteeScheduleViewController.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Classes/Driver/Common/Extensions/Place+Extensions.swift",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Constants/DynamicText+Features.swift",
//            "-emit-module",
//            "-emit-module-path",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Intermediates/Lyft.build/Debug-iphonesimulator/Lyft.build/Objects-normal/x86_64/Lyft.swiftmodule",
//            "-Xcc",
//            "-iquote",
//            "-Xcc",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Intermediates/Lyft.build/Debug-iphonesimulator/Lyft.build/Lyft-generated-files.hmap",
//            "-Xcc",
//            "-I/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Intermediates/Lyft.build/Debug-iphonesimulator/Lyft.build/Lyft-own-target-headers.hmap",
//            "-Xcc",
//            "-I/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Intermediates/Lyft.build/Debug-iphonesimulator/Lyft.build/Lyft-all-target-headers.hmap",
//            "-Xcc",
//            "-iquote",
//            "-Xcc",
//            "/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Intermediates/Lyft.build/Debug-iphonesimulator/Lyft.build/Lyft-project-headers.hmap",
//            "-Xcc",
//            "-I/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Products/Debug-iphonesimulator/include",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public/CardIO",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public/GoogleMaps",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public/GooglePlaces",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public/Instabug",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public/TrustDefenderMobile",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public/Tune",
//            "-Xcc",
//            "-I/Users/jsimard/src/Lyft-iOS/Pods/Headers/Public/WazeTransport",
//            "-Xcc",
//            "-I/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Intermediates/Lyft.build/Debug-iphonesimulator/Lyft.build/DerivedSources/x86_64",
//            "-Xcc",
//            "-I/Users/jsimard/Library/Developer/Xcode/DerivedData/Lyft-gljqccylldlaksftzvqzeuxcaali/Build/Intermediates/Lyft.build/Debug-iphonesimulator/Lyft.build/DerivedSources",
//            "-Xcc",
//            "-DCOCOAPODS=1",
//            "-import-objc-header",
//            "/Users/jsimard/src/Lyft-iOS/Lyft/Supporting Files/Swift Bridges & objc fixes/Lyft-Bridging-Header.h",
//            "-Xcc",
//            "-working-directory/Users/jsimard/src/Lyft-iOS"
//        ]
        let schemes = [
            "API",
            "CoreAPI-iOS",
            "LocationFeedbackNotification",
            "Lyft",
            "LyftAnalytics",
            "LyftKit-iOS",
            "LyftNetworking-iOS",
            "LyftUI",
            "Models",
            "RideUpdateNotification",
            "Siri",
            "SiriUI"
        ]
        for scheme in schemes {
        autoreleasepool {
        print("Adding missing selfs to \(scheme)")
        let module = String(scheme.split(separator: "-")[0].split(separator: " ")[0])
        let args = ["-workspace", "Lyft.xcworkspace", "-scheme", scheme]
        if let module = Module(xcodeBuildArguments: args, name: module) {
//        if let module = Module(spmName: moduleName) {
            // Find unused imports
//            for file in module.sourceFiles {
//                let unusedImports = File(path: file)!.unusedImports(compilerArguments: module.compilerArguments)
//                if !unusedImports.isEmpty {
//                    print("Unused imports in \(file.bridge().lastPathComponent):")
//                    for module in unusedImports {
//                        print("- \(module)")
//                    }
//                }
//            }

            // Find `private` or `fileprivate` declarations that aren't used within that file
            var fileIndex = 1
            for file in module.sourceFiles {
                let progress = "(\(fileIndex)/\(module.sourceFiles.count))"
                fileIndex += 1
                print("checking for missing explicit self references in '\(file)' \(progress)")
                let file = File(path: file)!
                let allCursorInfo = file.allCursorInfo(compilerArguments: module.compilerArguments)
//                print(toJSON(allCursorInfo))
                let cursorsMissingExplicitSelf = allCursorInfo.filter { cursorInfo in
                    guard let kindString = cursorInfo["key.kind"] as? String else { return false }
                    let isInstanceVarRef = (kindString == "source.lang.swift.ref.var.instance")
                    let hasExplicitSelfRef = (cursorInfo["key.containertypeusr"] != nil)
                    return isInstanceVarRef && !hasExplicitSelfRef
                }
//                print(toJSON(cursorsMissingExplicitSelf))
                let contents = file.contents.bridge().mutableCopy() as! NSMutableString
                for cursorInfo in cursorsMissingExplicitSelf.reversed() {
                    guard let byteOffset = cursorInfo["jp.offset"] as? Int64,
                        let nsrangeToInsert = contents.byteRangeToNSRange(start: Int(byteOffset), length: 0)
                    else { continue }
                    contents.replaceCharacters(in: nsrangeToInsert, with: "self.")
                }
                // Fix-up invalid insertions
                contents.replaceOccurrences(of: ".self.", with: ".",
                                            range: NSRange(location: 0, length: contents.length))
//                print(contents.bridge())
                guard let path = file.path else {
                    fatalError("file needs a path to call write(_:)")
                }
                guard let stringData = contents.bridge().data(using: .utf8) else {
                    fatalError("can't encode '\(contents)' with UTF8")
                }
                do {
                    try stringData.write(to: URL(fileURLWithPath: path), options: .atomic)
                } catch {
                    fatalError("can't write file to \(path)")
                }
//                let privateDeclarationUSRs = File.privateDeclarationUSRs(allCursorInfo: allCursorInfo)
//                let refUSRs = File.allRefUSRs(allCursorInfo: allCursorInfo)
//                let unusedPrivateDeclarations = Set(privateDeclarationUSRs).subtracting(refUSRs)
//                if !unusedPrivateDeclarations.isEmpty {
//                    print("Unused private declarations in \(file.path!.bridge().lastPathComponent):")
//                    print(unusedPrivateDeclarations)
//                }
            }
//
//            // Find `internal` declarations that should be `private` or `fileprivate`
//            var internalDeclarationsPerFile = [String: [String]]()
//            var refsPerFile = [String: [String]]()
//            var idx = 0
//            for file in module.sourceFiles {
//                idx += 1
//                print("\(file.bridge().lastPathComponent) (\(idx)/\(module.sourceFiles.count))")
//                let filesToSkip = [
//                    ""
//                ]
//                if filesToSkip.contains(file) {
//                    print("skipping")
//                    continue
//                }
//                let allCursorInfo = File(path: file)!.allCursorInfo(compilerArguments: module.compilerArguments)
//                internalDeclarationsPerFile[file] = File.internalDeclarationUSRs(allCursorInfo: allCursorInfo)
//                refsPerFile[file] = File.allRefUSRs(allCursorInfo: allCursorInfo)
//            }
//            if let testsModule = Module(spmName: moduleName + "Tests") {
//                idx = 0
//                for file in testsModule.sourceFiles {
//                    idx += 1
//                    print("\(file.bridge().lastPathComponent) (\(idx)/\(testsModule.sourceFiles.count))")
//                    let filesToSkip = [
//                        ""
//                    ]
//                    if filesToSkip.contains(file) {
//                        print("skipping")
//                        continue
//                    }
//                    let allCursorInfo = File(path: file)!.allCursorInfo(compilerArguments: testsModule.compilerArguments)
//                    refsPerFile[file] = File.allRefUSRs(allCursorInfo: allCursorInfo)
//                }
//            }
//            for (file, internalDeclarations) in internalDeclarationsPerFile {
//                var copy = refsPerFile
//                copy.removeValue(forKey: file)
//                let nonFileRefs = Array(copy.values).flatMap({ $0 })
//                for decl in internalDeclarations where !nonFileRefs.contains(decl) {
//                    print("\(file.bridge().lastPathComponent) decl is internal but not referenced in other files " +
//                          "from the module or its tests:")
//                    print(decl)
//                }
//            }
        }
        }
        }
        return .success(())
    }

    func runSwiftModule(moduleName: String?, args: [String]) -> Result<(), SourceKittenError> {
        let module = Module(xcodeBuildArguments: args, name: moduleName)

        if let docs = module?.docs {
            print(docs)
            return .success(())
        }
        return .failure(.docFailed)
    }

    func runSwiftSingleFile(args: [String]) -> Result<(), SourceKittenError> {
        if args.isEmpty {
            return .failure(.invalidArgument(description: "at least 5 arguments are required when using `--single-file`"))
        }
        let sourcekitdArguments = Array(args.dropFirst(1))
        if let file = File(path: args[0]),
           let docs = SwiftDocs(file: file, arguments: sourcekitdArguments) {
            print(docs)
            return .success(())
        }
        return .failure(.readFailed(path: args[0]))
    }

    func runObjC(options: Options, args: [String]) -> Result<(), SourceKittenError> {
        #if os(Linux)
        fatalError("unsupported")
        #else
        if args.isEmpty {
            return .failure(.invalidArgument(description: "at least 5 arguments are required when using `--objc`"))
        }
        let translationUnit = ClangTranslationUnit(headerFiles: [args[0]], compilerArguments: Array(args.dropFirst(1)))
        print(translationUnit)
        return .success(())
        #endif
    }
}

private let syntaxTypesToSkip = [
    "source.lang.swift.syntaxtype.attribute.builtin",
    "source.lang.swift.syntaxtype.keyword",
    "source.lang.swift.syntaxtype.number",
    "source.lang.swift.syntaxtype.doccomment",
    "source.lang.swift.syntaxtype.string",
    "source.lang.swift.syntaxtype.string_interpolation_anchor",
    "source.lang.swift.syntaxtype.attribute.id",
    "source.lang.swift.syntaxtype.buildconfig.keyword",
    "source.lang.swift.syntaxtype.buildconfig.id",
    "source.lang.swift.syntaxtype.comment.url",
    "source.lang.swift.syntaxtype.comment",
    "source.lang.swift.syntaxtype.doccomment.field"
]

extension File {
    fileprivate func allCursorInfo(compilerArguments: [String]) -> [[String: SourceKitRepresentable]] {
        // swiftlint:disable number_separator line_length
        let filesToSkip = [
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Passenger/CostEstimate.swift": [887],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Common/AppInfoConstants.swift": [2727, 3723],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Common/Mapper/Transform+Range.swift": [426],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Common/Ride.swift": [6344, 11478, 11533],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Passenger/PartySizePricing.swift": [349],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Common/CurrentUser.swift": [2766],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Passenger/NearbyCar.swift": [1371],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Common/Route.swift": [5009],
            "/Users/jsimard/src/Lyft-iOS/Lyft/Models/Passenger/RidePaymentDetails.swift": [1129, 1675, 1965],
            "/Users/jsimard/src/Lyft-iOS/Lyft/API/Common/LyftAPI+PassengerRide.swift": [10282]
        ]
        let editorOpen = Request.editorOpen(file: self).send()
        let syntaxMap = SyntaxMap(sourceKitResponse: editorOpen)
        return syntaxMap.tokens.flatMap { token in
            if let offsetsToSkip = filesToSkip[path!], offsetsToSkip.contains(token.offset) {
                return nil
            }
            var cursorInfo = Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                arguments: compilerArguments).send()
            if let acl = File.aclAtOffset(Int64(token.offset), editorOpen: editorOpen) {
                cursorInfo["key.accessibility"] = acl
            }
            cursorInfo["jp.offset"] = Int64(token.offset)
            return cursorInfo
        }
    }

    fileprivate static func privateDeclarationUSRs(allCursorInfo: [[String: SourceKitRepresentable]]) -> [String] {
        var usrs = [String]()
        let privateACLs = ["source.lang.swift.accessibility.private", "source.lang.swift.accessibility.fileprivate"]
        for cursorInfo in allCursorInfo {
            if let usr = cursorInfo["key.usr"] as? String,
                let kind = cursorInfo["key.kind"] as? String,
                kind.contains("source.lang.swift.decl"),
                let accessibility = cursorInfo["key.accessibility"] as? String,
                privateACLs.contains(accessibility) {
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate static func internalDeclarationUSRs(allCursorInfo: [[String: SourceKitRepresentable]]) -> [String] {
        var usrs = [String]()
        for cursorInfo in allCursorInfo {
            if let usr = cursorInfo["key.usr"] as? String,
                let kind = cursorInfo["key.kind"] as? String,
                kind.contains("source.lang.swift.decl"),
                let accessibility = cursorInfo["key.accessibility"] as? String,
                accessibility == "source.lang.swift.accessibility.internal" {
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate static func aclAtOffset(_ offset: Int64, editorOpen: [String: SourceKitRepresentable]) -> String? {
        if let nameOffset = editorOpen["key.nameoffset"] as? Int64,
            nameOffset == offset,
            let acl = editorOpen["key.accessibility"] as? String {
            return acl
        }
        if let sub = editorOpen[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable] {
            let sub2 = sub.map({ $0 as! [String: SourceKitRepresentable] })
            for subsub in sub2 {
                if let acl = File.aclAtOffset(offset, editorOpen: subsub) {
                    return acl
                }
            }
        }
        return nil
    }

    fileprivate static func allRefUSRs(allCursorInfo: [[String: SourceKitRepresentable]]) -> [String] {
        var usrs = [String]()
        for cursorInfo in allCursorInfo {
            if let usr = cursorInfo["key.usr"] as? String,
                let kind = cursorInfo["key.kind"] as? String,
                kind.contains("source.lang.swift.ref") {
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate func allUSRs(compilerArguments: [String]) -> [String] {
        let syntaxMap = SyntaxMap(sourceKitResponse: Request.editorOpen(file: self).send())
        var usrs = [String]()
        for token in syntaxMap.tokens where !syntaxTypesToSkip.contains(token.type) {
            let cursorInfo = Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                arguments: compilerArguments).send()
            if let usr = cursorInfo["key.usr"] as? String {
                print(toJSON(cursorInfo))
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate func unusedImports(compilerArguments: [String]) -> [String] {
        if (path ?? "").contains("File.swift") ||
            (path ?? "").contains("String+SourceKitten.swift") {
            return []
        }
        let syntaxMap = SyntaxMap(sourceKitResponse: Request.editorOpen(file: self).send())
        var imports = [String]()
        var usrs = [String]()
        var nextIsModuleImport = false
        for token in syntaxMap.tokens {
            if token.type == "source.lang.swift.syntaxtype.keyword",
                let substring = contents.bridge()
                    .substringWithByteRange(start: token.offset, length: token.length),
                substring == "import" {
                nextIsModuleImport = true
                continue
            }
            if syntaxTypesToSkip.contains(token.type) {
                continue
            }
            let cursorInfo = Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                arguments: compilerArguments).send()
            if nextIsModuleImport {
                if let importedModule = cursorInfo["key.modulename"] as? String,
                    cursorInfo["key.kind"] as? String == "source.lang.swift.ref.module" {
                    imports.append(importedModule)
                    nextIsModuleImport = false
                }
            } else {
                nextIsModuleImport = false
            }
            if let usr = cursorInfo["key.usr"] as? String {
                usrs.append(usr)
            }
        }
        return imports.filter { module in
            return !["Foundation", "Swift", "Dispatch"].contains(module) &&
                usrs.filter({ $0.contains(module) }).isEmpty
        }
    }
}
