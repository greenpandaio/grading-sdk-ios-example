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
                privacyPolicy: true,
                assessments: tradeInAssessments
            )
        case .eligibilityPeer:
            return EligibilityPeerConfig(
                privacyPolicy: true
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
