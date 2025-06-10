//
//  ContentView.swift
//  Background
//
//  Created by Lukasz Kostka on 03/06/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var uwb = UWBDevices()
    var body: some View {
        VStack {
            if uwb.devices.isEmpty {
                ProgressView()
            } else {
                Text("You can now close the app, lock your iPhone, and see the Live Activity on the screen.")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
