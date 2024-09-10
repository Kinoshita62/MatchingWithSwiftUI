//
//  AuthViewModel.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/07.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        print("ログインユーザー: \(self.userSession?.email)")
        Task {
            await self.fetchCurrentUser()
        }
    }
    
    //Login
    @MainActor
    func login(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("ログイン成功: \(result.user.email)")
            self.userSession = result.user
            print("\(self.userSession): \(self.userSession?.email)")
        } catch {
            print("ログイン失敗: \(error.localizedDescription)")
        }
    }
    
    //Logout
    func logout(){
        do {
            try Auth.auth().signOut()
            print("ログアウト成功")
            self.userSession = nil
        } catch {
            print("ログアウト失敗 :\(error.localizedDescription)")
        }
        
    }
    
    
    //create Account
    @MainActor
    func createAccount(email: String, password: String, name: String, age: Int) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("成功: \(result.user.email)")
            self.userSession = result.user
            let newUser = User(id: result.user.uid, name: name, email: email, age: age)
            await uploadUserData(withUser: newUser)
        }catch {
            print("失敗: \(error.localizedDescription)")
            
        }
        
    }
    
    //Delete Account
    
    //Uplpad User Data
    private func uploadUserData(withUser user: User) async {
        
        do {
            let userData = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(userData)
            print("データ保存成功")
        } catch {
            print("データ保存失敗: \(error.localizedDescription)")
        }
        
    }
    
    //Fetch current user
    @MainActor
    private func fetchCurrentUser() async {
        
        guard let uid = self.userSession?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
            print("カレントユーザー取得成功: \(self.currentUser)")
        } catch {
            print("カレントユーザー取得失敗: \(error.localizedDescription)")
        }
    }
    
    //Update user profile
    func updateUserProfile(withID id: String, name: String, age: Int, message: String)  async {
        let data: [AnyHashable: Any] = [
            "name": name,
            "age": age,
            "message": message
        ]
        do {
            try await Firestore.firestore().collection("users").document(id).updateData(data)
            print("プロフィール更新成功")
            await self.fetchCurrentUser()
        } catch {
            print("プロフィール更新失敗: \(error.localizedDescription)")
        }
        
    }
    
}
