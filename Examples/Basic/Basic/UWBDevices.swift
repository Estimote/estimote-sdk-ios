//
//  UWBDevices.swift
//  EstimoteSDK
//
//  Created by Estimote on 2024-12-16.

import Foundation
import EstimoteSDK

/*
 📋 Permissions & Capabilities Setup

To use EstimoteSDK properly, ensure the following entries are added to your app's Info.plist:

- `NSBluetoothAlwaysUsageDescription`:
  A string explaining why your app needs Bluetooth access.

- `NSNearbyInteractionUsageDescription`:
  A string explaining why your app uses Nearby Interaction (required for UWB).

- `NSCameraUsageDescription` (optional):
  Required if you enable camera-assisted positioning for improved accuracy.

To test UWB functionality while the app is in the background, enable Background Modes in your project’s Capabilities, and check the following options:
- Uses Bluetooth LE accessories
- Uses Nearby Interaction
*/

class UWBDevices: ObservableObject {
    
    let manager = EstimoteDeviceManager()
    @Published var devices: [EstimoteDevice] = []
    
    init() {
        // Optional: Schedule configuration updates for specific devices
        // try? manager.scheduleDeviceConfigurationsUpdate(SAMPLE_DEVICE_CONFIGURATIONS)
        
        let configuration = EstimoteScanConfiguration(useCameraAssistance: true)
        manager.startScanning(configuration: configuration)
        
        // Observe distance updates with distance (in meters) and angle (if available) from UWB-enabled devices
        manager.observeDistanceUpdates { update in // watch out for retain cycles
            print("Identifier: \(update.deviceIdentifier), Distance: \(update.distance), Angle: \(update.angle ?? 0)")
        }
        
        // Observe proximity updates from Estimote BLE Beacons
        manager.observeProximityUpdates { update in // watch out for retain cycles
            print("Identifier: \(update.deviceIdentifier), RSSI: \(update.rssi), Estimated proximity: \(update.estimatedZone.description)")
        }
        
        // Optionally, observe general device state changes (e.g. discovered, connected, disconnected)
        manager.observeDeviceUpdates { update in
            print("Device: \(update.deviceIdentifier), State: \(update.state)")
        }
        
        // Directly update @Published `devices`
        manager.$nearbyDevices
            .assign(to: &$devices)
        
//        manager.observeProximityUpdates()
//            .receive(on: DispatchQueue.main)
//            .sink { print($0) }
//            .store(in: &cancellables)
    }

//    // To use delegates, add `@preconcurrency EstimoteDeviceUpdatesDelegate` to the class set `manager.delegate = self` in the init()
//
//    @MainActor
//    func didUpdateDistance(_ update: DistanceUpdate) {
//        let device = EstimoteDevice(deviceIdentifier: update.deviceIdentifier, distance: update.distance)
//        
//        if let index = devices.firstIndex(where: { $0.id == update.deviceIdentifier }) {
//            devices[index] = device
//        } else {
//            devices.append(device)
//        }
//    }
//    
//    @MainActor
//    func didDiscover(deviceIdentifier: EstimoteDeviceIdentifier) {
//        manager.connect(to: deviceIdentifier)
//        
//        // optionally, disconnect after e.g. 20 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
//            self.manager.disconnect(from: deviceIdentifier)
//        }
//    }
}
