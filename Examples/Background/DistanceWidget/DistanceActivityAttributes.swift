//
//  DistanceActivityAttributes.swift
//  Background
//
//  Created by Lukasz Kostka on 03/06/2025.
//

import ActivityKit

struct DistanceActivity: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var distance: Float        // metres (live value)
        var identifier: String
    }

    var title: String
}
