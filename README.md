# Estimote SDK for iOS (next generation)

> **Compatibility Notice**
> This SDK supports Estimote UWB Beacons manufactured **after March 2025**. Earlier hardware revisions are not compatible.

**EstimoteSDK** is a Swift framework for scanning, connecting, and interacting with Estimote UWB Proximity Beacons using Bluetooth Low Energy (BLE) and Ultra-Wideband (UWB) technology. It provides a simple and modern API leveraging Combine for reactive programming, making it easy to integrate proximity and location-based features into your iOS applications. Whether you're developing indoor navigation, asset tracking, or proximity marketing applications, this SDK provides the tools you need to interact with Estimote Beacons efficiently.

## Features

- **Easy Scanning and Discovery**: Start scanning for nearby Estimote devices with minimal code; with support for both BLE and UWB technologies.
- **Distance and Proximity Updates**: Receive real-time distance and proximity updates from devices.
- **Device Configuration**: Schedule and apply configuration updates to devices.


## Installation

**EstimoteSDK** is distributed via *Swift Package Manager*. To integrate it into your Xcode project:

1. Open your project in Xcode.
2. Go to *File > Add Packages...*
3. Enter the EstimoteSDK GitHub repository URL:

   `https://github.com/Estimote/estimote-sdk-ios.git`

4. Select the latest available version (e.g. `1.0.0-beta`) or specify a version range:

   `.package(url: "https://github.com/Estimote/estimote-sdk-ios.git", from: "1.0.0-beta")`

Make sure **EstimoteSDK** is added to your target.

## Usage

### Quick Start

To quickly build a functional demo with minimal effort, use the following snippet.

```
import SwiftUI
import EstimoteSDK

struct ContentView: View {
    let manager = EstimoteDeviceManager()
    var body: some View {
        VStack {
            List(manager.nearbyDevices) { device in
                VStack(alignment: .leading) {
                    Text(device.id)
                    
                    Text(String(format: "%.2f meters", device.distance))
                }
            }
        }
        .onAppear {
            manager.startScanning()
        }
    }
}
```

For a more comprehensive implementation, refer to the Examples and the following documentation.

### Configuration

You can customize the scanning behavior by providing an `EstimoteScanConfiguration` object. Available configuration options include:

- **`manualConnectionManagement`**: Determines whether connection management is handled manually by the user. Default is `false`, meaning connections are automatic. Set to `true` if you want explicit control over when and how devices are connected.
- **`useCameraAssistance`**: Enables camera-assisted positioning for more precise distance and angle measurements on supported devices. Default is `false`.
- **`continueScanningInBackground`**: Allows the app to continue scanning for devices when running in the background. Updates may be less frequent due to iOS limitations. Default is `false`. This may require enabling **Background Modes** in your project capabilities with the **Uses Bluetooth LE accessories** option selected.
- **`enableDistanceUpdatesInBackground`**: Enables continued distance updates for UWB devices in the background. This requires the connection to start in the foreground and for the user to pair with the device. Default is `false`. Also requires enabling **Background Modes** with **Uses Nearby Interaction** and **Uses Bluetooth LE accessories** selected in your project capabilities.

```swift
import EstimoteSDK

let deviceManager = EstimoteDeviceManager()
let configuration = EstimoteScanConfiguration(useCameraAssistance: true)

deviceManager.startScanning(configuration: configuration)
``` 

Ensure the necessary keys are included in your app's `Info.plist`:

- `NSBluetoothAlwaysUsageDescription`: EstimoteSDK requires Bluetooth access to communicate with nearby Estimote Beacons.
- `NSNearbyInteractionUsageDescription`: EstimoteSDK requires Nearby Interaction access to measure distance to nearby Estimote Beacons.
- Optionally, `NSCameraUsageDescription`: EstimoteSDK requires Camera access to precisely measure distance and angle to nearby Estimote devices.

### Observing Distance Updates

Prefer using Combine publishers over delegates for a modern and reactive approach.

```swift
deviceManager.observeDistanceUpdates { update in
    print("Distance to device \(update.deviceIdentifier): \(update.distance) meters, angle: \(update.angle ?? 0)")
}
```
The `observeDistanceUpdates` method automatically delivers updates on the main dispatch queue to ensure UI compatibility.
For fine-grained control, you can use the publisher directly.

```swift
deviceManager.observeDistanceUpdates()
    .receive(on: DispatchQueue.main)
    .sink { update in
        print("Distance to device \(update.deviceIdentifier): \(update.distance) meters")
        // Update your UI or perform actions based on the distance; watch out for retain cycles
    }
    .store(in: &cancellables)
```

If you have a specific reason to avoid Combine, you could fall back on using a delegate by defining a protocol, adding it to the manager, and implementing it in your code.

```swift
class DistanceUpdateHandler: EstimoteDeviceUpdatesDelegate {
    func didUpdateDistance(_ update: DistanceUpdate) {
        print("Distance to \(update.deviceIdentifier): \(update.distance) meters")
    }
}

let deviceManager = EstimoteDeviceManager()
let distanceDelegate = DistanceUpdateHandler()
deviceManager.delegate = distanceDelegate
deviceManager.startScanning()
```

### Observing Proximity Updates

EstimoteSDK also supports scanning for Estimote's BLE-only devices.

```swift
deviceManager.observeProximityUpdates { update in
    print("Device: \(update.deviceIdentifier), RSSI: \(update.rssi)")
}
```

## Advanced Usage

### Device Configuration

You can schedule device configuration updates with `DeviceConfiguration`, and these configurations are applied when the device is connected for the first time.

```swift
let configurations = [
    DeviceConfiguration(
        deviceIdentifier: EstimoteDeviceIdentifier("your-device-id"),
        iBeacon: IBeaconConfiguration(uuid: UUID(), major: 100, minor: 200),
        eddystone: EddystoneConfiguration(namespaceID: "namespace", instanceID: "instance")
    )
]

deviceManager.scheduleDeviceConfigurationsUpdate(configurations)
```

### Manually Managing Connections

While it's recommended to use automatic connection, you can manually connect to devices if needed. You can only do so after a device has been discovered.

```swift
deviceManager.observeDeviceUpdates() { update in
    guard update.state == .discovered else { return }
    manager.connect(to: update.deviceIdentifier)
}
```

Or by using the `didDiscover(deviceIdentifier: EstimoteDeviceIdentifier)` delegate.

## Some more background on Ultra Wideband Technology in iOS

### NearbyInteraction

Introduced in iOS 14, the NearbyInteraction framework enables precise spatial positioning between devices using UWB technology. This allows for accurate distance and direction measurements, essential for applications like indoor navigation and spatial awareness. Camera assistance improves accuracy and stability, particularly for angle measurements on supported iPhones.

### Ultra-Wideband (UWB) Technology

Ultra-Wideband (UWB) is a short-range wireless communication protocol that operates across a wide spectrum of high frequencies, typically between 3.1 GHz and 10.6 GHz. Unlike narrowband communication protocols, UWB transmits data using very short pulses over a broad frequency range, which gives it the ability to carry out precise time-of-flight (ToF) calculations. These calculations measure the time it takes for a signal to travel from one device to another, allowing for highly accurate distance and directional measurements.

Apple introduced UWB support with the U1 chip in iPhone 11 models and later, excluding iPhone SE (2nd and 3rd generation).

UWB is capable of centimeter-level precision for distance measurements, with an accuracy typically within **10 cm** under optimal conditions. The precision depends on factors such as signal quality, environmental interference, and device implementation.

#### Physics Behind UWB:
- **Wide Bandwidth**: The large frequency range minimizes multipath interference, as reflections of the signal arrive at different times and can be separated from the direct signal.
- **High Frequency**: Operating at high frequencies reduces the wavelength, making it easier to measure small distances and detect angular variations.
- **Low Power**: UWB's short pulses spread across a wide frequency range, resulting in low spectral power density, which minimizes interference with other radio systems.

#### BLE vs UWB:

- **Proximity and Distance**:  
  BLE uses RSSI for proximity and distance but is limited to meter-level accuracy and affected by interference. UWB uses time-of-flight (ToF) for centimeter-level accuracy, unaffected by obstacles.

- **Angle Measurement**:  
  BLE lacks angle measurement, while UWB supports angle-of-arrival (AoA) for directional data. UWB combined with camera systems and AR enhances accuracy and stability.

- **iOS Support**:  
  BLE works on all modern iOS devices. UWB requires a U1 chip, available on iPhone 11 and newer (excluding iPhone SE).

- **Power Efficiency**:  
  BLE is highly efficient for long-term use. UWB uses slightly more power but delivers superior precision and advanced features.


## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
