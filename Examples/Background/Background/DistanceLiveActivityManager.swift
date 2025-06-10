//
//  DistanceLiveActivityManager.swift
//  Background
//
//  Created by Lukasz Kostka on 03/06/2025.
//

import Foundation
import ActivityKit
import Combine

final class DistanceLiveActivityManager {

    private var activity: Activity<DistanceActivity>?
    private var bag = Set<AnyCancellable>()

    func start(distancePublisher: AnyPublisher<(String, Float), Never>) {

        let startContent = ActivityContent(
            state: DistanceActivity.ContentState(distance: 0, identifier: "n/a"),
            staleDate: .now.addingTimeInterval(300) // stale after 5 minutes
        )

        do {
            activity = try Activity.request(
                attributes: DistanceActivity(title: "Distance"),
                content:   startContent,
                pushType:  nil
            )
        } catch {
            print("Live-Activity request failed:", error)
            return
        }

        distancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] identifier, distance in
                Task { await self?.update(identfier: identifier, distance: distance) }
            }
            .store(in: &bag)
    }

    @MainActor
    private func update(identfier: String, distance: Float) async {
        guard let activity else { return }
        let content = ActivityContent(
            state: DistanceActivity.ContentState(distance: distance, identifier: identfier),
            staleDate: .now.addingTimeInterval(300)
        )
        await activity.update(content)
    }

    func stop() {
        Task {
            if let activity {
                let finalContent = ActivityContent(
                    state: DistanceActivity.ContentState(distance: 0, identifier: "n/a"),
                    staleDate: nil)
                await activity.end(finalContent,
                                   dismissalPolicy: .immediate)
            }
        }
        bag.removeAll()
    }
}
