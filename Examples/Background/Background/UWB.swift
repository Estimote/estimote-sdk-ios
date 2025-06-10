//
//  UWB.swift
//  Background
//
//  Created by Lukasz Kostka on 03/06/2025.
//

import Foundation
import Combine
import EstimoteSDK
import ActivityKit

final class UWBDevices: ObservableObject {

    // MARK: – public device list
    @Published var devices: [EstimoteDevice] = []

    // MARK: – private
    private let manager  = EstimoteDeviceManager()
    private let liveActivity = DistanceLiveActivityManager()
    private let distanceUpdates = PassthroughSubject<(String, Float),Never>()
    private var bag = Set<AnyCancellable>()

    init() {

        // 1️⃣ start the Live Activity, bound to a Combine publisher
        liveActivity.start(distancePublisher: distanceUpdates.eraseToAnyPublisher())

        // 2️⃣ kick off scanning (ARSession can't work in background)
        let cfg = EstimoteScanConfiguration(useCameraAssistance: false, continueScanningInBackground: true, enableDistanceUpdatesInBackground: true)
        manager.startScanning(configuration: cfg)

        // 3️⃣ push every distance update down the pipe
        manager.observeDistanceUpdates { [weak self] update in
            self?.distanceUpdates.send((update.deviceIdentifier, update.distance))
        }

        manager.$nearbyDevices
            .assign(to: &$devices)
    }

    deinit {                       // make sure it disappears when you do
        liveActivity.stop()
    }
}
