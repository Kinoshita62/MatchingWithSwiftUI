//
//  ListViewModel.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/05.
//

import Foundation
import FirebaseFirestore

class ListViewModel: ObservableObject {
    @Published var users = [User]()
    
    private var currentIndex = 0
    
    @MainActor
    init() {
        //self.users = getMockUsers()
        Task {
            self.users = await fetchUsers()
        }
    }
    
    private func getMockUsers() -> [User] {
        return [
            User.MOCK_USER1,
            User.MOCK_USER2,
            User.MOCK_USER3,
            User.MOCK_USER4,
            User.MOCK_USER5,
            User.MOCK_USER6,
            User.MOCK_USER7
        ]
    }
    
    //Download Users Data
    private func fetchUsers() async -> [User] {
        do {
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            
            var tempUsers = [User]()
            for document in snapshot.documents {
                let user = try document.data(as: User.self)
                print("user: \(user)")
                tempUsers.append(user)
            }
            return tempUsers
        } catch {
            print("ユーザーデータ取得失敗: \(error.localizedDescription)")
            return []
        }
    }
    
    func adjustIndex(isRedo: Bool) {
        if isRedo {
            currentIndex -= 1
        } else {
            currentIndex += 1
        }
    }
    
    func tappedHandler(action: Action) {
        switch action {
        case .nope, .like:
            if currentIndex >= users.count {return}
        case .redo:
            if currentIndex <= 0 {return}

        }
        NotificationCenter.default.post(name: Notification.Name("ACTIONFORMBUTTON"), object: nil, userInfo: [
            "id": action == .redo ? users[currentIndex - 1].id : users[currentIndex].id,
            "action": action
        ])
    }
}
