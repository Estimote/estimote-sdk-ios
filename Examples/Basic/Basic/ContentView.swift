//
//  ContentView.swift
//  EstimoteSDK
//
//  Created by Estimote on 2024-12-16.

import SwiftUI

struct ContentView: View {
    @ObservedObject private var uwbDevices = UWBDevices()
    
    var body: some View {
        VStack {
            if uwbDevices.devices.isEmpty {
                ProgressView()
            }
            
            List(uwbDevices.devices) { device in
                VStack(alignment: .leading) {
                    Text(device.id)
                    
                    HStack {
                        Text(String(format: "%.2f meters", device.distance))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        ArrowView(angle: device.angle).foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct ArrowView: View {
    var angle: Float?

    var body: some View {
        if let angle = angle {
            Text("↑")
                .rotationEffect(.degrees(Double(angle * 90)))
                .animation(.easeInOut, value: angle * 90)
        } else {
            EmptyView()
        }
    }
}


#Preview {
    ContentView()
}
