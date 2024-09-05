//
//  Action.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/05.
//

import SwiftUI

enum Action {
    case nope
    case redo
    case like
}

extension Action: CaseIterable {
    
    func createActionButton(viewModel: ListViewModel) -> some View {
        Button {
            viewModel.tappedHandler(action: self)
        } label: {
            Image(systemName: self.symbol)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(self.color)
                .background {
                    Circle()
                        .stroke(self.color, lineWidth: 1)
                        .frame(width: self.size, height: self.size)
                }
        }
    }
    
    private var symbol: String {
        switch self {
        case .nope:
            return "xmark"
        case .redo:
            return "arrow.counterclockwise"
        case .like:
            return "heart.fill"
        }
    }
    
    private var color: Color {
        switch self {
        case .nope:
            return .red
        case .redo:
            return .yellow
        case .like:
            return .mint
        }
    }
    
    private var size: CGFloat {
        switch self {
            
        case .nope, .like:
            return 60
        case .redo:
            return 40

        }
    }
    
}
