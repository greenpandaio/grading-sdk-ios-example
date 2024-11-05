#Pandas Grading SDK

### iOS Project Requirements

Deployment target: iOS 12
Swift version: 5.0

## Installing the library

### Swift Package Manager

In the project's Package Dependencies add a new dependency for url https://github.com/greenpandaio/grading-sdk-ios-spm and set the desired version.

After the PandasGradingSDK package is fetched, drag and drop the PandasGradingSDK.bundle from the package contents folder to the project root checking "Copy items if needed".
Then include it in the project's target(Project settings -> targets -> Frameworks, Libraries & Embedded Content -> Add PandasGradingSDK).

For the CocoaPods legacy installation refer to [the cocoa pod installation instructions](CocoaPodsInstall.md)

## Configuring the SDK

A complete example wrapper class which integrates the SDK can be found [here](/IosSDKIntegration/SDKWrapper.swift)

### Construct your basic configuration object:

```swift
        let gradingSDKConfig = GradingSDKConfig(
            environment: .staging,
            partner: Partner(
                id: "eb7c5e49-a4af-4426-93e4-4d1dd800b9ad",
                name: "pandas",
                code: "pandas"
            ),
            theme: Theme(
                colors: ThemeColors(
                    mainColor: "#222222"
                ),
                fonts: ThemeFonts( // UIFont supported font family
                    primary: "Helvetica",
                    secondary: "Helvetica"
                                 ),
                customStrings: nil // Optional Override content with custom strings.xml url
            )
        )

```

Before starting the SDK you need to call the `configure` public method of `PandasGrading` shared instance with the corresponding configuration object:

```swift
PandasGrading.shared.configure(sdkConfig: gradingSDKConfig)
```

### Environment configuration

The environment can be set with the `environment` parameter. `.staging`,`.uat` or `.production`.
Note: When `.staging` is set, all cosmetic evaluation tests will result in dummy successfull responses.

## Using the SDK

### Create a per flow configuration.

The SDK supports the following flows:

- `FlowConfigBase.TradeInConfig.TradeInConfigHome(params explained below)` - Evaluates the device for trade in from home

- `FlowConfigBase.TradeInConfig.TradeInConfigStore(params explained below)` - Evaluates the device for trade in at a store

- `FlowConfigBase.EligibilityConfig(params explained below)` - Evaluates the current device for warranty eligibility'

- `FlowConfigBase.EligibilityPeerConfig(params explained below)` - Evaluates another device for warranty eligibility

### Start a device assessment flow

The grading flow is started using the `startGrading` function of PandasGrading shared instance.

```swift
        PandasGrading.shared.startGrading(
            navigationController: yourUInavigationController //The instance of the calling UINavigationController,
            flowConfig: flowConfiguration //Your flow configuration(See below),
            sessionId: sessionId //Optional Session id to resume.,
            imei: imei //Optional the IMEI of the device for identification and analytics.
        )

```

### Available flow configurations

#### Eligibility

Evaluates the current device for warranty eligibility

##### Define an ordered list of assessments(tests) that need to be performed.

```swift
        let tradeInAssessments: [GradingTest] = [
            .cosmeticGrading,
            .digitizer,
            .soundPerformance,
        ]
            flowConfiguration =  EligibilityConfig(
                privacyPolicy: true, // Toggles privacy policy consent screen
                assessments: tradeInAssessments // Configures the tests that are going to be performed.
            )
```

#### EligibilityPeer

Evaluates another device for warranty eligibility

```swift
            flowConfiguration =  EligibilityPeerConfig(
                privacyPolicy: true // Toggles privacy policy consent screen
            )
```

#### Eligibility flows - Results output

The eligibility flow completion handling is done by implementing the PandasGradingDelegate protocol. The instance of the class implementing the protocol must be set on the PandasGrading shared instance delegate property. The protocol contains a method which provides an EligibilityFlowResult parameter, which can have the following values: success, failed or skipped as well as the session id.

`public protocol PandasGradingDelegate: AnyObject {
    func eligibilityFlowEnded(result: EligibilityFlowResult)
}`

for example

```swift
extension AppDelegate: PandasGradingDelegate {
    func eligibilityFlowEnded(sessionId: String,
                              result: EligibilityFlowResult) {
        print("\n\neligibility flow for session: \(sessionId), ended with result: \(result)\n\n")
    }
}
```

### TradeInAtHome - TradeInAtStore

##### Define an ordered list of assessments(tests) that need to be performed.

```swift
        let tradeInAssessments: [GradingTest] = [
            .cosmeticGrading,
            .digitizer,
            .soundPerformance,
            .multitouch,
            .deviceMotion,
            .biometrics,
            .frontCamera,
            .backCamera
        ]
```

##### (Home flow only) Define the available device drop off options

```swift
let tradeInDropOffOptions: [DropOffOption] = [.atStore, .courierAtStore]
```

##### Initialise a TradeInConfigHome or TradeInConfigStore object

```swift
            flowConfiguration = TradeInConfig(
                flowType: .home,
                privacyPolicy: false, // Toggles privacy policy consent screen
                assessments: tradeInAssessments,// Configures the tests that are going to be performed.
                emailSubmission: false, //Requires user email to display the offer
                dropOffOptions: tradeInDropOffOptions, // Configures which drop off options are available for trade in.
                storeLocationsUrl: tradeInLocationsUrl //Loads the store locations webpage url in a webview
            )
```

### Privacy usage descriptions

Depending on the assessments that are going to be configured, the SDK needs permission for certain device capabilities.
Therefore the app needs to include in the `Info.plist` file the following items:

- Privacy - Camera Usage Description (Camera tests)
- Privacy - Face ID Usage Description (Biometrics tests)
- Privacy - Location When In Use Usage Description (TradeInFromHome flow)
- Privacy - Microphone Usage Description (Sound test)

In case any of theese tests are not configured, the corresponding permissions are not required.

## Extended configuration.

colorConfig , fontConfig , stringsURL are optional and should be provided if you want to override the default values.

### Color scheme

The color scheme is updated by providing a `ColorConfig` object, containing the color hex values. The colors which should not be updated can be omitted from the color config

**Sample**

```
let colorConfig = ColorConfig(shadow: UIColor(hex: "#F5F5F5"),
                              border: UIColor(hex: "#E0E0E0"),
                              white: UIColor(hex: "#FFFFFF"),
                              red: UIColor(hex: "#FF5151"),
                              light_red: UIColor(hex: "#FFDBDD"),
                              green: UIColor(hex: "#1FAD43"),
                              concrete: UIColor(hex: "#F2F2F2"),
                              light_green: UIColor(hex: "#BBFFCC80"),
                              aero_blue: UIColor(hex: "#BBFFCC"),
                              dark: UIColor(hex: "#1D1D1D"),
                              dark_2: UIColor(hex: "#1A1A1A"),
                              nobel: UIColor(hex: "#B3B3B3"),
                              grey: UIColor(hex: "#6C6C6C"),
                              grey_light: UIColor(hex: "#93989E"),
                              grey_lighter: UIColor(hex: "#cccccc"),
                              gray_4: UIColor(hex: "#808080"),
                              gray_5: UIColor(hex: "#666666"),
                              gray_6: UIColor(hex: "#717171"),
                              background_grey: UIColor(hex: "#F7F7F7"),
                              brand_new: UIColor(hex: "#CE90FF"),
                              brand_new_light UIColor(hex: "#E1C8FB"),
                              good: UIColor(hex: "#79E795"),
                              good_light: UIColor(hex: "#DAFAE5"),
                              poor: UIColor(hex: "#FFBF00"),
                              poor_light: UIColor(hex: "#FDEDA6"),
                              fail: UIColor(hex: "#FF4B55"))

```

### Media items customisations

There are two kinds of media item types: images and animations

#### Images

The images can be customised by setting in the app's main bundle (e.g. Assets folder) images with same name as the images you want to override.

The image names are described in the enum below:

```
enum ImageItem: String {
    case arrowTop = "arrow-top"
    case backCamera = "back-camera"
    case backCameraIcon = "back-camera-icon"
    case backCameraStore = "back-camera-store"
    case backIcon = "back-icon"
    case camera = "camera"
    case carEco = "car-eco"
    case circleChevronRight = "circle-chevron-right"
    case closeIcon = "close-icon"
    case courierUnavailable = "courier-unavailable"
    case deviceError = "device-error"
    case deviceIdentified = "device-identified"
    case deviceMotion = "device-motion"
    case deviceTreeIcon = "device-tree-icon"
    case digitizer = "digitizer"
    case digitizerTestImage = "digitizer-test-image"
    case disconnectBluetoothIcon = "disconnect-bluetooth-icon"
    case dotsIcon = "dots-icon"
    case environmentObjectIcon = "environment-object-icon"
    case evaluateDigitizer2 = "evaluate-digitizer-2"
    case evaluatingIcon = "evaluating-icon"
    case evaluationFailedIcon = "evaluation-failed-icon"
    case faceId = "face-id"
    case faceIdIcon = "face-id-icon"
    case faceIdSmall = "face-id-small"
    case faqDropdown = "faq-dropdown"
    case fastIcon = "fast-icon"
    case findImeiIos = "find-imei-ios"
    case fingerprintIcon = "fingerprint-icon"
    case frontCamera = "front-camera"
    case frontCameraIcon = "front-camera-icon"
    case frontCameraStore = "front-camera-store"
    case gyroscopeIcon = "gyroscope-icon"
    case help = "help"
    case holdingPhone = "holding-phone"
    case infoIcon = "info-icon"
    case kioskIcon = "kiosk-icon"
    case kioskCharacter = "kiosk-character"
    case likeHeart = "like-heart"
    case lineBottomLeft = "line-bottom-left"
    case lineBottomRight = "line-bottom-right"
    case lineTopLeft = "line-top-left"
    case lineTopRight = "line-top-right"
    case locateIcon = "locate-icon"
    case magicWand = "magic-wand"
    case microphone = "microphone"
    case mirrorTutorial1 = "mirror_tutorial_1"
    case mirrorTutorial2 = "mirror_tutorial_2"
    case mirrorTutorial3 = "mirror_tutorial_3"
    case mirrorTutorial4 = "mirror_tutorial_4"
    case motionInstructions = "motion-instructions"
    case multitouch = "multitouch"
    case multitouchIcon = "multitouch-icon"
    case multitouchTwo = "multitouch-two"
    case multitouchThree = "multitouch-three"
    case objectDetection = "object-detection"
    case ourStory = "our-story"
    case ourManifesto = "our-manifesto"
    case popUpMultitouchTryAgain = "pop-up-multitouch-try-again"
    case popUpSoundFailIcon = "pop-up-sound-fail-icon"
    case popupTouchScreenNotWorkingIcon = "pop-up-touch-sceennot-working-icon"
    case privacyIcon = "privacy-icon"
    case redRectangleBottomLeft = "red-rectangle-bottom-left"
    case redRectangleBottomRight = "red-rectangle-bottom-right"
    case redRectangleTopLeft = "red-rectangle-top-left"
    case redRectangleTopRight = "red-rectangle-top-right"
    case reportCosmetics = "report-cosmetics"
    case reuseIcon = "reuse-icon"
    case screenIcon = "screen-icon"
    case sensorIcon = "sensor-icon"
    case socialFacebook = "social-facebook"
    case socialInstagram = "social-instagram"
    case socialLinkedin = "social-linkedin"
    case socialTikTok = "social-tiktok"
    case socialYoutube = "social-youtube"
    case speaker = "speaker"
    case speakersIcon = "speakers-icon"
    case splashScreen = "splash-screen"
    case statusPoor = "status-poor"
    case tradeAtm = "trade-atm"
    case tradeCourierSmall = "trade-courier-small"
    case tradeinOffer = "tradein-offer"
    case treeIcon = "tree-icon"
    case volumeDownButton = "volume-down-button"
    case volumeUpButton = "volume-up-button"
    case warningFaceId = "warning-faceid"
    case warningCircleIcon = "warning-circle-icon"
    case warningIcon = "warning-icon"
    case worksOkIcon = "works-ok-icon"

}
```

#### Animations

The animations can be customized by setting in the app's main bundle files with same name as the animations you want to override.
The file format should be mp4 for videos and gif for the logo.

The animation names are described in the enum below:

```
enum AnimationItem: String {
    case evaluateDigitizer = "evaluate-digitizer.mp4"
    case likeHeart = "like-heart.mp4"
    case logo = "white-logo.gif"
    case tutorial1 = "carousel-trade-in.mp4"
    case tutorial2 = "carousel-evaluation.mp4"
    case tutorial3 = "carousel-dropoff.mp4"
}
```
