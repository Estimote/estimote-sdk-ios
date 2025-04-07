//
//  UWBDeviceConfigurations.swift
//  EstimoteSDK
//
//  Created by Estimote on 2024-12-16.

import EstimoteSDK

let SAMPLE_DEVICE_CONFIGURATIONS = [
    DeviceConfiguration(
        deviceIdentifier: EstimoteDeviceIdentifier("*"), // using a wildcard will apply the configuration to any Estimote UWB Beacon the SDK connects to; use Estimote Device Identifier (16 bytes / 32 hexadecimal characters) to narrow down to just one device
        iBeacon: IBeaconConfiguration(
            uuid: UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE"),
            major: 2025,
            minor: nil // setting it to nil will randomize the value
        ),
        eddystone: EddystoneConfiguration(
            namespaceID: "AAAABBBBCCCCDDDDEEEE",
            instanceID: nil // setting it to nil will randomize the value
        )
    )
    // …
]
