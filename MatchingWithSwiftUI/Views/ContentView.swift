//
//  ContentView.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/04.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                ListView()
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
