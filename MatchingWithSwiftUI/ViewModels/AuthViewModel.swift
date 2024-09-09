//
//  AuthViewModel.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/07.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        print("\(self.userSession?.email)")
        
        //Test for logout
//        logout()
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
    func createAccount(email: String, password: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("成功: \(result.user.email)")
            self.userSession = result.user
        }catch {
            print("失敗: \(error.localizedDescription)")
            
        }
        
    }
    
    //Delete Account
    
}
