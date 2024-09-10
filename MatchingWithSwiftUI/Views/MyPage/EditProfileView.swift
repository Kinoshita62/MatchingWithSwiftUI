//
//  EditProfileView.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/09.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var selectedImage: PhotosPickerItem? = nil
    @State var name = ""
    @State var age = 18
    @State var message = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                //Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                //Edit Field
                editField
            }
            .navigationTitle("プロフィール変更")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("変更") {
                        Task {
                            guard let currentUser = authViewModel.currentUser else { return }
                            await authViewModel.updateUserProfile(
                                withID: currentUser.id,
                                name: name,
                                age: age,
                                message: message)
                            dismiss()
                        }
                    }
                }
            }
            .font(.subheadline)
            .foregroundStyle(.primary)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(AuthViewModel())  // プレビューにオブジェクトを渡す
    }
}


extension EditProfileView {
    private var editField: some View {
        VStack(spacing: 16) {
            //PhotoPicker
            PhotosPicker(selection: $selectedImage) {
                ZStack {
                    Image("avatar")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 150)
                    
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.white.opacity(0.75))
                        .frame(width: 60)
                }
                
            }
            
            //InputField
            InputField(text: $name, label: "お名前", placeholder: "")
            PickerField(selection: $age, title: "年齢")
            InputField(text: $message, label: "メッセージ", placeholder: "入力してください", withDivider: false)
        }
        .padding(.horizontal)
        .padding(.vertical, 32)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        }
        .padding()
        .onAppear {
            if let currentUser = authViewModel.currentUser {
                name = currentUser.name
                age = currentUser.age
                message = currentUser.message ?? ""
            }
        }
    }
}
