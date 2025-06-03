//
//  ContentView.swift
//  LegitimuzSdkIntegrationSampleIOS
//
//  Created by Christian Santos on 6/2/25.
//

import SwiftUI
import LegitimuzSDKPackage

struct ContentView: View {
    @State private var showVerification = false
    @State private var currentEvent: String = "Ready to start"
    @State private var verificationComplete = false
    @State private var cpf: String = ""
    @State private var referenceId: String = ""
    @State private var selectedAction: LegitimuzAction = .signup
    @State private var verificationType: LegitimuzVerificationType = .kyc
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                Text("Legitimuz SDK Sample")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Status
                Text(currentEvent)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .multilineTextAlignment(.center)
                
                // Input Section
                if !verificationComplete {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CPF")
                                .font(.headline)
                            TextField("Enter CPF (or use 555.555.555-55 for demo)", text: $cpf)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            if !cpf.isEmpty && !LegitimuzSDK.validateCPF(cpf) {
                                Text("Invalid CPF")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reference ID (Optional)")
                                .font(.headline)
                            TextField("Enter reference ID", text: $referenceId)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Action Context")
                                .font(.headline)
                            Picker("Action", selection: $selectedAction) {
                                Text("Signup").tag(LegitimuzAction.signup)
                                Text("Signin").tag(LegitimuzAction.signin)
                                Text("Withdraw").tag(LegitimuzAction.withdraw)
                                Text("Password Change").tag(LegitimuzAction.passwordChange)
                                Text("Account Details").tag(LegitimuzAction.accountDetailsChange)
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Verification Type")
                                .font(.headline)
                            Picker("Type", selection: $verificationType) {
                                Text("KYC").tag(LegitimuzVerificationType.kyc)
                                Text("SOW (Source of Wealth)").tag(LegitimuzVerificationType.sow)
                                Text("Face Index").tag(LegitimuzVerificationType.faceIndex)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    if verificationComplete {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                            
                            Text("Verification Complete!")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Button("Start Again") {
                                verificationComplete = false
                                currentEvent = "Ready to start"
                                cpf = ""
                                referenceId = ""
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    } else {
                        Button("Start Verification") {
                            showVerification = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!isFormValid)
                        
                        Button("Use Demo CPF") {
                            cpf = "55555555555"
                            referenceId = "demo-user-123"
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showVerification) {
            VerificationView(
                cpf: cpf,
                referenceId: referenceId.isEmpty ? nil : referenceId,
                action: selectedAction,
                verificationType: verificationType,
                currentEvent: $currentEvent,
                verificationComplete: $verificationComplete
            )
        }
    }
    
    private var isFormValid: Bool {
        !cpf.isEmpty && LegitimuzSDK.validateCPF(cpf)
    }
}

struct VerificationView: View {
    @Environment(\.dismiss) private var dismiss
    let cpf: String
    let referenceId: String?
    let action: LegitimuzAction
    let verificationType: LegitimuzVerificationType
    @Binding var currentEvent: String
    @Binding var verificationComplete: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text(currentEvent)
                    .padding()
                    .font(.headline)
                
                // Use the new session-generating WebView
                createVerificationWebView()
            }
            .navigationTitle("Verification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func createVerificationWebView() -> AnyView {
        let configuration = LegitimuzConfiguration(
            host: URL(string: "https://api.legitimuz.com")!, // Your production API host
            token: "4f83c2e7-4750-4405-ac00-f7a5deba10c8", // Your actual API token
            appURL: URL(string: "https://widget.legitimuz.com")!, // Widget URL (default)
            language: "pt", // Language: "pt", "en", or "es"
            enableDebugLogging: true, // Enable for development
            enableInspection: false // Enable for WebView debugging (iOS 16.4+)
        )
        let eventHandlers = LegitimuzEventHandlers(
            onEvent: { event in
                DispatchQueue.main.async {
                    handleEvent(event)
                }
            },
            onSuccess: { eventName in
                print("✅ Success: \(eventName)")
                DispatchQueue.main.async {
                    currentEvent = "✅ Success in \(eventName)"
                }
            },
            onError: { eventName in
                print("❌ Error: \(eventName)")
                DispatchQueue.main.async {
                    currentEvent = "❌ Error in \(eventName)"
                }
            }
        )
        
        // Create the appropriate WebView based on verification type
        switch verificationType {
        case .kyc:
            return AnyView(
                LegitimuzWebView.forKYCVerification(
                    configuration: configuration,
                    cpf: LegitimuzSDK.cleanCPF(cpf),
                    referenceId: referenceId,
                    action: action,
                    eventHandlers: eventHandlers
                )
            )
        case .sow:
            return AnyView(
                LegitimuzWebView.forSOWVerification(
                    configuration: configuration,
                    cpf: LegitimuzSDK.cleanCPF(cpf),
                    referenceId: referenceId,
                    action: action,
                    eventHandlers: eventHandlers
                )
            )
        case .faceIndex:
            return AnyView(
                LegitimuzWebView.forFaceIndexVerification(
                    configuration: configuration,
                    cpf: LegitimuzSDK.cleanCPF(cpf),
                    referenceId: referenceId,
                    action: action,
                    eventHandlers: eventHandlers
                )
            )
        }
    }
    
    private func handleEvent(_ event: LegitimuzEvent) {
        switch event.name {
        case "page_loaded":
            currentEvent = "✅ Session loaded, ready to start"
        case "session_generation_failed":
            currentEvent = "❌ Failed to generate session"
        case "ocr":
            if event.status == "success" {
                currentEvent = "📄 Document processed successfully"
            } else {
                currentEvent = "📄 Processing document..."
            }
        case "facematch":
            if event.status == "success" {
                currentEvent = "👤 Face verification successful"
            } else {
                currentEvent = "👤 Verifying face..."
            }
        case "liveness":
            if event.status == "success" {
                currentEvent = "🔍 Liveness check passed"
            } else {
                currentEvent = "🔍 Liveness check in progress..."
            }
        case "sow":
            if event.status == "success" {
                currentEvent = "💰 SOW verification completed"
            } else {
                currentEvent = "💰 Processing SOW verification..."
            }
        case "faceindex":
            if event.status == "success" {
                currentEvent = "🎯 Face indexing completed"
            } else {
                currentEvent = "🎯 Face indexing in progress..."
            }
        case "close-modal":
            currentEvent = "🎉 Verification completed!"
            verificationComplete = true
            dismiss()
        case "modal":
            if event.status == "close" {
                currentEvent = "🎉 Verification completed!"
                verificationComplete = true
                dismiss()
            }
        default:
            currentEvent = "📝 \(event.name): \(event.status)"
        }
        
        print("Event: \(event.name), Status: \(event.status)")
        if let refId = event.refId {
            print("Reference ID: \(refId)")
        }
    }
}



#Preview {
    ContentView()
}
