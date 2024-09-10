//
//  CardView.swift
//  MatchingWithSwiftUI
//
//  Created by USER on 2024/09/04.
//

import SwiftUI

struct CardView: View {
    
    @State private var offset: CGSize = .zero
    let user: User
    let adjustIndex: (Bool) -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            //background
            Color(.black)
            //image
            imageLayer
            //gradient
            LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
            //information
            informationLayer
            
            //LikeAndNope
            LikeAndNope
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .offset(offset)
        .gesture(gesture)
        .scaleEffect(scale)
        .rotationEffect(.degrees(angle))
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFORMBUTTON"), object: nil)) { data in
            receiveHandler(data: data)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(AuthViewModel())  // プレビューにオブジェクトを渡す
    }
}

//MARK: -UI
extension CardView {
    private var  imageLayer: some View {
        Group {
            if let urlString = user.photoUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth - 16)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100)
            }
        }
    }
    
    private var informationLayer: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Text(user.name)
                    .font(.largeTitle.bold())
                Text("\(user.age)")
                    .font(.title2)
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.blue, .white)
                    .frame(width: 22, height: 22)
            }
            
            if let message = user.message {
                Text(message)
            }

        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    private var LikeAndNope: some View {
        HStack {
            Text("LIKE")
                .likeNopeText(isLike: true)
                .opacity(opacity)
            Spacer()
            Text("NOPE")
                .likeNopeText(isLike: false)
                .opacity(-opacity)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        
        
    }
}


//MARK: -Action
extension CardView {
    
    private var screenWidth: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0.0 }
        return window.screen.bounds.width
    }
    
    private var scale: CGFloat {
        return max((1.0 - (abs(offset.width) / screenWidth)), 0.75)
    }
    
    private var angle: Double {
        return (offset.width / screenWidth) * 10.0
    }
    
    private var opacity: Double {
        return (offset.width / screenWidth) * 4.0
    }
    
    private func removeCard(isLiked: Bool, height: CGFloat = 0.0) {
        withAnimation(.smooth) {
            offset = CGSize(width: isLiked ? screenWidth * 1.5 : -screenWidth * 1.5, height: height)
        }
        adjustIndex(false)
    }
    
    private func resetCard(fromButton: Bool = false) {
        withAnimation(.smooth) {
            offset = .zero
        }
        if fromButton {
            adjustIndex(true)

        }
    }
    
    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let width = value.translation.width
                let height = value.translation.height
                
                let limitedHeight = height > 0 ? min(height, 100) : max(height, -100)
                
                offset = CGSize(width: width, height: limitedHeight)
            }
            .onEnded { value in
                
                let width = value.translation.width
                let height = value.translation.height
                
                if (abs(width) > (screenWidth / 4)) {
                    removeCard(isLiked: width > 0, height: height)
                } else {
                    resetCard()
                }
            }
    }
    
    private func receiveHandler(data: NotificationCenter.Publisher.Output) {
        guard
            let info = data.userInfo,
            let id = info["id"] as? String,
            let action = info["action"] as? Action
        else { return }
        
        if id == user.id {
            switch action {
                
            case .nope:
                removeCard(isLiked: false)
            case .redo:
                resetCard(fromButton: true)
            case .like:
                removeCard(isLiked: true)
            }
        }
    }
}

