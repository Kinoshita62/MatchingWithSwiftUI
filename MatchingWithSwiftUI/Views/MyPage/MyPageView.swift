//
//  MyPageView.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/09.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEditProfileView = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        List {
            
            //Ussr Info
            Section {
                userInfo
            }
            
            //System Info
            Section("一般") {
                MyPageRow(iconName: "gear", label: "バージョン", tintColor: .gray, value: "1.0.0")
            }
            
            
            //Navigation
            Section("アカウント") {
                Button {
                    showEditProfileView.toggle()
                } label: {
                    MyPageRow(iconName: "square.and.pencil.circle.fill", label: "プロフィール変更", tintColor: .red)
                }
                
                Button {
                    authViewModel.logout()
                } label: {
                    MyPageRow(iconName: "arrow.left.circle.fill", label: "ログアウト", tintColor: .red)
                }
                
                Button {
//
                    showDeleteAlert = true
                } label: {
                    MyPageRow(iconName: "xmark.circle.fill", label: "アカウント削除", tintColor: .red)
                }
                .alert("アカウント削除", isPresented: $showDeleteAlert) {
                    Button("キャンセル") {}
                    Button("削除") { Task { await authViewModel.deleteAccount() } }
                } message: {
                    Text("アカウントを削除しますか？")
                }

            }
            
        }
        .sheet(isPresented: $showEditProfileView, content: {
            EditProfileView()
        })
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
            .environmentObject(AuthViewModel())  // プレビューにオブジェクトを渡す
    }
}

extension MyPageView {
    private var userInfo: some View {
        HStack(spacing: 16) {
            if let urlString = authViewModel.currentUser?.photoUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 48, height: 48 )
                }
            } else {
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(authViewModel.currentUser?.name ?? "")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(authViewModel.currentUser?.email ?? "")
                    .font(.footnote)
                    .tint(.gray)
            }
        }
    }
}
