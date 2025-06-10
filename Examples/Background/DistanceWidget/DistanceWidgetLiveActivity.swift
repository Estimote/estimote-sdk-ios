//
//  DistanceWidgetLiveActivity.swift
//  DistanceWidget
//
//  Created by Lukasz Kostka on 03/06/2025.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct DistanceLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DistanceActivity.self) { ctx in    // Lock-screen & StandBy
            VStack {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(String(format: "%.1f", ctx.state.distance))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    Text(" m")                                // thin‑space
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                Text("Distance to \(ctx.state.identifier)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding()
        } dynamicIsland: { ctx in                                     // Dynamic Island
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text(String(format: "%.1f m", ctx.state.distance)).bold()
                }
            } compactLeading: {
                Image(systemName: "figure.walk")
            } compactTrailing: {
                Text(String(format: "%.1f", ctx.state.distance))
                    .monospacedDigit()
            } minimal: {
                Text(String(format: "%.1f", ctx.state.distance))
                    .monospacedDigit()
            }
        }
    }
}
