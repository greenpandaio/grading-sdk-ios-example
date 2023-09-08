//
//  ContentView.swift
//  IosSDKIntegration
//
//  Created by Anestis Kyvranoglou on 15/6/23.
//

import SwiftUI
import PandasGradingSDK;
struct ContentView: View {
        @State var isPresented = false
        
        var body: some View {
            Button("Start Pandas Grading SDK") {
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                SDKView()
                    .ignoresSafeArea()

            }
            
        }
    }

struct SDKView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SDKViewController
    
    func makeUIViewController(context: Context) -> SDKViewController {
        PandasGrading.shared.configure(imei:nil, environment : .staging ,colorConfig: nil,
                                       fontConfig: nil,
                                       stringsURL: Bundle.main.url(forResource: "Strings-en", withExtension: "xml"),
                                       configURL: Bundle.main.url(forResource: "config", withExtension: "json"))

        let vc = SDKViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SDKViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
