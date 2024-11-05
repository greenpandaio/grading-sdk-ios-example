import Foundation
import UIKit
import PandasGradingSDK

public class SDKWrapper {
    private var context: UINavigationController
    
    public init(appContext: UINavigationController) {
        self.context = appContext
        let gradingSDKConfig = GradingSDKConfig(
            environment: .staging,
            partner: Partner(
                id: "82562551-eb28-4801-a0ca-e3b5c79c5101",
                name: "T mobile",
                code: "t_mobile_demo"
            ),
            theme: Theme(
                colors: ThemeColors(
                    mainColor: "#E20074"
                ),
                images: ThemeImages(
                    splashScreen: nil,
                    digitizer: UIImage(named: "digitizer-image"),
                    qrLogo: UIImage(named: "qr")
                ),
                fonts: ThemeFonts( // UIFont supported font family
                    primary: "SF Pro",
                    secondary: "TeleNeo"
                                 ),
                customStrings: nil // Overide content with custom strings.xml url
            )
        )
        PandasGrading.shared.configure(sdkConfig: gradingSDKConfig)
    }
    
    private func getConfigPerFlow(flowType: GradingFlow) -> FlowConfigBase {
        let tradeInLocationsUrl = "https://www.pandas.io/el-GR/map"
        let tradeInAssessments: [GradingTest] = [
            .cosmeticGrading,
            .digitizer,
            .soundPerformance,
            //.multitouch,
            //.deviceMotion,
            //.biometrics,
            //.frontCamera,
            //.backCamera
        ]
        
        let tradeInDropOffOptions: [DropOffOption] = [.atStore, .courierAtStore]
        switch flowType {
        case .home:
            return TradeInConfig(
                flowType: .home,
                privacyPolicy: false,
                assessments: tradeInAssessments,
                emailSubmission: false,
                dropOffOptions: tradeInDropOffOptions,
                storeLocationsUrl: tradeInLocationsUrl
            )
        case .store:
            return TradeInConfig(
                flowType: .store,
                privacyPolicy: false,
                assessments: tradeInAssessments,
                emailSubmission: false,
                dropOffOptions: tradeInDropOffOptions,
                storeLocationsUrl: tradeInLocationsUrl
            )
        case .eligibility:
            return EligibilityConfig(
                privacyPolicy: false,
                assessments: tradeInAssessments
            )
        case .eligibilityPeer:
            return EligibilityPeerConfig(
                privacyPolicy: false
            )
        }
    }
    
    public func startFlow(flowType: GradingFlow, sessionId: String? = nil, imei: String? = nil) {
        let flowConfiguration = getConfigPerFlow(flowType: flowType)
        
        PandasGrading.shared.startGrading(
            navigationController: context,
            flowConfig: flowConfiguration,
            sessionId: sessionId,
            imei: imei
        )
    }
}
