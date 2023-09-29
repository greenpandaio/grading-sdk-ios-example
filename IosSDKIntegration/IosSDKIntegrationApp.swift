//
//  IosSDKIntegrationApp.swift
//  IosSDKIntegration
//
//  Created by Anestis Kyvranoglou on 15/6/23.
//

import SwiftUI
import PandasGradingSDK
@main
struct IosSDKIntegrationApp: App {
    
    init() {
        configureGradingSDK()
    }
    
    func configureGradingSDK() {
        PandasGrading.shared.configure(imei:nil, environment : .staging ,colorConfig: nil,
                                       fontConfig: nil,
                                       stringsURL: Bundle.main.url(forResource: "Strings-en", withExtension: "xml"),
                                       configURL: Bundle.main.url(forResource: "config", withExtension: "json"))
    }
    
    @State var isPresented = false
    @State var sessionId: String? = nil
    @State var gradingFlow: GradingFlow! = .store
    
    var body: some Scene {
        WindowGroup {
            ContentView(isPresented: $isPresented,
                        sessionId: $sessionId,
                        gradingFlow: $gradingFlow)
            // triggered when app is in memory
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: { activity in
                handleOpenURL(url: activity.webpageURL)
            })
            
            // triggered when app is launched
            .onOpenURL { url in
                handleOpenURL(url: url)
            }
            .fullScreenCover(isPresented: $isPresented) {
                SDKView(flow: $gradingFlow,
                        sessionId: $sessionId)
            }
        }
    }
    
    func handleOpenURL(url: URL?) {
        guard let url = url else {
            return
        }
        
        var sessionId: String?
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
           let queryItems = urlComponents.queryItems {
            sessionId = queryItems.first(where: { $0.name == "sessionId" })?.value
        }
        
        configureGradingSDK()
        self.sessionId = sessionId
        self.gradingFlow = .store
        isPresented = true

        
    }
     
}
