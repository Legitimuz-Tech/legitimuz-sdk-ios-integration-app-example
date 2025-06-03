# Legitimuz SDK iOS Integration Sample

A comprehensive sample iOS application demonstrating the integration of the Legitimuz SDK for identity verification services. This SwiftUI-based app showcases various verification types including KYC (Know Your Customer), SOW (Source of Wealth), and Face Index verification.

## 🚀 Features

### Verification Types
- **KYC Verification**: Complete Know Your Customer identity verification
- **SOW Verification**: Source of Wealth verification for compliance
- **Face Index**: Facial recognition and indexing

### Action Contexts
- **Signup**: New user registration verification
- **Signin**: User authentication verification
- **Withdraw**: Transaction-based verification
- **Password Change**: Security verification for password updates
- **Account Details**: Verification for account modifications

### Key Capabilities
- ✅ CPF validation and formatting
- ✅ Real-time event tracking and status updates
- ✅ Configurable verification parameters
- ✅ Demo mode with test CPF
- ✅ Comprehensive error handling
- ✅ WebView-based verification interface
- ✅ Multi-language support (Portuguese, English, Spanish)

## 📋 Requirements

### System Requirements
- **iOS**: 14.0+
- **Xcode**: 13.0+
- **Swift**: 5.5+

### Permissions Required
The app requires the following permissions for verification processes:
- **Camera**: For document scanning and facial verification
- **Microphone**: For liveness detection
- **Location**: For enhanced security verification

## 🛠 Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd LegitimuzSdkIntegrationSampleIOS
```

### 2. Open in Xcode
```bash
open LegitimuzSdkIntegrationSampleIOS.xcodeproj
```

### 3. Configure SDK Dependencies
The project uses Swift Package Manager to integrate the Legitimuz SDK:
- The `LegitimuzSDKPackage` is already configured in the project
- Ensure you have internet connectivity for package resolution

### 4. Update Configuration
In `ContentView.swift`, update the configuration parameters:

```swift
let configuration = LegitimuzConfiguration(
    host: URL(string: "https://api.legitimuz.com")!, // Your API host
    token: "YOUR_API_TOKEN_HERE", // Replace with your actual API token
    appURL: URL(string: "https://widget.legitimuz.com")!, // Widget URL
    language: "pt", // Language: "pt", "en", or "es"
    enableDebugLogging: true, // Enable for development
    enableInspection: false // Enable for WebView debugging (iOS 16.4+)
)
```

### 5. Build and Run
- Select your target device or simulator
- Press `Cmd + R` to build and run

## 🎯 Usage Guide

### Basic Flow
1. **Enter CPF**: Input a valid Brazilian CPF number
2. **Reference ID**: (Optional) Add a reference identifier
3. **Select Action**: Choose the context for verification
4. **Choose Type**: Select verification type (KYC, SOW, or Face Index)
5. **Start Verification**: Launch the verification process

### Demo Mode
For testing purposes, use the "Use Demo CPF" button to populate:
- **CPF**: `555.555.555-55`
- **Reference ID**: `demo-user-123`

### Event Tracking
The app provides real-time feedback during verification:
- ✅ Session loaded confirmation
- 📄 Document processing status
- 👤 Face verification progress
- 🔍 Liveness check results
- 💰 SOW verification status
- 🎯 Face indexing progress
- 🎉 Completion confirmation

## 🏗 Project Structure

```
LegitimuzSdkIntegrationSampleIOS/
├── LegitimuzSdkIntegrationSampleIOS/
│   ├── ContentView.swift              # Main UI and verification logic
│   ├── LegitimuzSdkIntegrationSampleIOSApp.swift  # App entry point
│   ├── Info.plist                     # App permissions and configuration
│   └── Assets.xcassets/               # App assets and icons
├── LegitimuzSdkIntegrationSampleIOSTests/        # Unit tests
├── LegitimuzSdkIntegrationSampleIOSUITests/      # UI tests
└── LegitimuzSdkIntegrationSampleIOS.xcodeproj/   # Xcode project file
```

## 🔧 Configuration Options

### LegitimuzConfiguration Parameters
- **host**: API endpoint URL
- **token**: Authentication token for API access
- **appURL**: Widget application URL
- **language**: Interface language ("pt", "en", "es")
- **enableDebugLogging**: Debug mode for development
- **enableInspection**: WebView inspection (iOS 16.4+)

### Verification Types
```swift
enum LegitimuzVerificationType {
    case kyc        // Know Your Customer
    case sow        // Source of Wealth
    case faceIndex  // Face Indexing
}
```

### Action Contexts
```swift
enum LegitimuzAction {
    case signup
    case signin
    case withdraw
    case passwordChange
    case accountDetailsChange
}
```

## 🎪 Demo Features

### Test CPF
The app includes a demo CPF (`555.555.555-55`) for testing purposes. This allows you to:
- Test the verification flow without real user data
- Demonstrate the app functionality
- Validate integration setup

### Event Simulation
The app handles various verification events:
- Page loading confirmation
- Document processing feedback
- Face verification status
- Liveness detection results
- Completion notifications

## 🐛 Troubleshooting

### Common Issues

1. **Session Generation Failed**
   - Verify API token is correct
   - Check network connectivity
   - Ensure API host URL is accessible

2. **Invalid CPF Error**
   - Use valid CPF format (11 digits)
   - Try the demo CPF: `555.555.555-55`
   - Check CPF validation logic

3. **Camera/Microphone Access**
   - Grant necessary permissions in device settings
   - Restart app after permission changes

4. **WebView Loading Issues**
   - Check internet connectivity
   - Verify widget URL accessibility
   - Enable debug logging for more details

### Debug Mode
Enable debug logging in configuration:
```swift
enableDebugLogging: true
```

This provides detailed console output for troubleshooting.

## 📱 Supported Platforms

- **iOS**: 14.0+
- **iPadOS**: 14.0+
- **Devices**: iPhone 6s and newer, iPad (5th generation) and newer

## 🔒 Security Considerations

- API tokens should be securely managed in production
- Sensitive data is processed through secure WebView
- All verification data is handled by Legitimuz servers
- Local data storage is minimal and temporary

## 📝 Development Notes

### Event Handling
The app implements comprehensive event handling:
```swift
let eventHandlers = LegitimuzEventHandlers(
    onEvent: { event in /* Handle all events */ },
    onSuccess: { eventName in /* Handle success */ },
    onError: { eventName in /* Handle errors */ }
)
```

### WebView Integration
Different WebView instances for each verification type:
- `LegitimuzWebView.forKYCVerification()`
- `LegitimuzWebView.forSOWVerification()`
- `LegitimuzWebView.forFaceIndexVerification()`

## 🤝 Contributing

When contributing to this sample:
1. Follow Swift coding conventions
2. Update documentation for new features
3. Test on multiple iOS versions
4. Ensure proper error handling

## 📞 Support

For SDK-related questions or issues:
- Check the Legitimuz SDK documentation
- Contact Legitimuz support team
- Review console logs with debug mode enabled

## 📄 License

This sample application is provided for demonstration purposes. Please refer to your Legitimuz SDK license agreement for usage terms.

---

**SDK Version**: Compatible with LegitimuzSDKPackage latest version 2.3.1 or superior.