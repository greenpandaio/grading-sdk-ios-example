# Using the Pandas Grading SDK

## iOS Project Requirements

Deployment target: iOS 12
Swift version: 5.0

### Privacy usage descriptions

The grading flow needs permission for certain device capabilities.
Therefore the app needs to include in the `Info.plist` file the following items:
- Privacy - Camera Usage Description
- Privacy - Face ID Usage Description
- Privacy - Location When In Use Usage Description
- Privacy - Microphone Usage Description

## Installing the library
### Swift Package Manager
In the project's Package Dependencies add a new dependency for url https://github.com/greenpandaio/grading-sdk-ios-spm and set the desired version.

After the PandasGradingSDK package is fetched, drag and drop the PandasGradingSDK.bundle from the package contents folder to the project root  checking "Copy items if needed".
Then include it in the project's target(Project settings -> targets -> Frameworks, Libraries & Embedded Content -> Add PandasGradingSDK).


For the CocoaPods legacy installation refer to [the cocoa pod installation instructions](CocoaPodsInstall.md)

## Configuring the SDK

Before starting the SDK you need to call the `configure` public method of `PandasGrading` shared instance
Having a configuration file (config.json or any other name) is mandatory and should be bundled along with your app's assets.

colorConfig , fontConfig , stringsURL are optional and should be provided if you want to override the default values.

**Sample**

```
PandasGrading.shared.configure(imei: imei,
                               environment: .staging,
                               colorConfig: nil,
                               fontConfig: nil,
                               stringsURL: Bundle.main.url(forResource: "Strings-en", withExtension: "xml"),
                               configURL: Bundle.main.url(forResource: "config", withExtension: "json"))

```

### IMEI

If the imei number of the device is known, it can be passed in the configure method, using the `imei` parameter.

### Environment configuration

The environment can be set with the `environment` parameter, setting the desired case `.staging` or `.production`. 

### Grading flow configuration

The grading flow configuration is set using the `configURL` parameter, which is the bundle URL containing the json file with the configuration parameters. 

The config properties are:
- partner - An object containing the name, flow, country, code, storeLocationsURL and id of the partner
- assessments - An array containing the device tests for grading
- payment_options - An object containing info about the payment options
- colors - An object containing the primary color setting
- email_submission - A boolean indicating if the send quote via email screen should be displayed
- drop_off_options - The dropoff options for the flow
- tutorial - A boolean indicating if the tutorial screen should be displayed
- impact - A boolean indicating if the impact screen should be displayed
- manifesto - A boolean indicating if the manifesto screen should be displayed
- our_story - A boolean indicating if our story screen should be displayed
- faq - A boolean indicating if the FAQ screen should be displayed
- contact_us - A boolean indicating if the contact us screen should be displayed
- contact_us_email - The URL of the API endpoint where the contact form will be submitted
- social_media - An object containg social media URLs

**Sample**

The config.json should have the following format.

```
{
    "partner": {
        "name": "your partner name",
        "storeLocationsURL": "url with your store locations",
        "id": "your partner id"
    },
    "assessments": [
        "digitizer",
        "sound-performance",
        "multitouch",
        "face-id",
        "device-motion",
        "front-camera",
        "back-camera"
    ],
    "colors": { "primary": "#1A1A1A" },
    "email_submission": true,
    "drop_off_options": ["AT_STORE", "COURIER_AT_STORE"],
    "tutorial": true,
    "impact": true,
    "manifesto": true,
    "our_story": true,
    "faq": true,
    "contact_us": true,
    "contact_us_email": "https://hook.eu1.make.com/ee2twfux18a5pg1ei7n0kkzmd4h4agrz",
    "social_media": {
        "instagram": "https://www.instagram.com/pandas.io/",
        "facebook": "https://www.facebook.com/pandasHQ/",
        "youtube": "https://www.youtube.com/channel/UCZlgTN_61nkmUTS9LLi9yEg/",
        "tiktok": "https://www.tiktok.com/@pandas_io/",
        "linkedin": "https://www.linkedin.com/company/wearepandas/"
    },
}


```

### Strings

The strings .xml file should be provided using the stringsURL parameter which is the local URL of the strings file. Example file :
[pandas-sdk-strings.xml](/ConfigAssets/Strings-en.xml)


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

### Font scheme

The font scheme is updated by providing a `FontConfig` object containing the font family name for primary, secondary and tertiary, and an array of the font file names.
The fontFileNames parameter is optional if the fonts are already registered for use.

**Sample**

```
let fontConfig = FontConfig(primary: "Open Sans",
                            secondary: "Source Sans",
                            tertiary: "Trebuchet",
                            fontFileNames: ["OpenSansRegular.tff", OpenSansMedium.ttf"])
```

### Media items customizations

There are two kinds of media item types: images and animations

#### Images

The images can be customized by setting in the app's main bundle (e.g. Assets folder) images with same name as the images you want to override.

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

## Using the SDK

The grading flow is started using the `startGrading` function of PandasGrading shared instance. The function parameter is an instance of UINavigationController which the SDK will use for navigating through the flow.
The navigation controller is to be presented immediately after the call to the `startGrading` func.

**Sample**

```
PandasGrading.shared.startGrading(navigationController: gradingNavigationController)
gradingNavigationController.modalPresentationStyle = .overFullScreen
present(gradingNavigationController, animated: true)
```
