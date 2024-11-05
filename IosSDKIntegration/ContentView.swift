//
//  ContentView.swift
//  IosSDKIntegration
//
//  Created by Anestis Kyvranoglou on 15/6/23.
//

import SwiftUI
import PandasGradingSDK

struct ContentView: View {
    @Binding var isPresented: Bool
    @Binding var sessionId: String?
    @Binding var gradingFlow: GradingFlow!
    
    var body: some View {
        Button("Start Pandas Grading SDK") {
            gradingFlow = .eligibility
            sessionId = nil
            isPresented = true
        }
        .fullScreenCover(isPresented: $isPresented) {
            SDKView(flow: $gradingFlow,
                    sessionId: $sessionId)
            .ignoresSafeArea()
            
        }
        
    }
}

struct SDKView: UIViewControllerRepresentable {
    
    @Binding var flow: GradingFlow!
    @Binding var sessionId: String?
    
    func makeUIViewController(context: Context) -> UINavigationController {

        let gradingNavigationController = GradingNavigationViewController()
        var sdkWrapper = SDKWrapper(appContext: gradingNavigationController)
        sdkWrapper.startFlow(flowType: flow, sessionId: sessionId,imei: nil);
        gradingNavigationController.modalPresentationStyle = .overFullScreen

        return gradingNavigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Update the view controller if needed
    }
}

