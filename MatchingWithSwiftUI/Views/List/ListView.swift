//
//  ListView.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/04.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject private var viewModel = ListViewModel()
    
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.users.count > 0 {
                    VStack(spacing: 0) {
                        //card
                        cards
                        
                        //action
                        actions
                    }
                    .background(.black, in: RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 6)
                } else {
                    ProgressView()
                        .padding()
                        .tint(Color.white)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .scaleEffect(1.5)
                }
                
            }
            .navigationTitle("Fire Match")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BrandImage(size: .small)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MyPageView()
                    } label: {
                        if let urlString = authViewModel.currentUser?.photoUrl, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 32, height:32)
                            }
                        } else {
                            Image("avatar")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .tint(.primary)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(AuthViewModel())  // プレビューにオブジェクトを渡す
    }
}

extension ListView {
    private var cards: some View {
        ZStack {
            ForEach(viewModel.users.reversed()) { user in
                CardView(user: user) { isRedo in
                    viewModel.adjustIndex(isRedo: isRedo)
                }
            }
        }
    }
    
    private var actions: some View {
        HStack(spacing: 68) {
            ForEach(Action.allCases, id:\.self) { type in
                type.createActionButton(viewModel: viewModel)
            }
        }
        .frame(height: 100)
        .foregroundStyle(.white)
    }
}
