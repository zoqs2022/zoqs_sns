//
//  SNS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import FirebaseFirestore


struct SNS: View {
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        VStack() {
            ForEach(self.postViewModel.posts, id: \.id) { (post) in
                VStack(spacing: 5) {
                    HStack(alignment: .top) {
                        PhotoCircleView(image: post.userImage, diameter: 40)
                        VStack(alignment: .leading) {
                            HStack {
                                Text(post.userName ?? "")
                                    .fontWeight(.bold)
                            }
//                            Text(String(post.date)).foregroundColor(.gray)
                            Text(post.text)
                            Image("flower")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 10)
                    Divider()
                }
            }
        }
    }
}

//struct SNS_Previews: PreviewProvider {
//    static var previews: some View {
//        SNS()
//    }
//}
