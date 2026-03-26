//
//  ContentView.swift
//  Math App
//
//  Created by Дмитрий on 25.03.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        RootView()
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelContainer.shared)
}
