//
//  SNS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import FirebaseFirestore


struct SNS: View {
    @StateObject var viewModel = PostViewModel(model: [PostModel()])
    
    var body: some View {
            VStack() {
                ForEach(self.viewModel.posts, id: \.id) { (post) in
                    VStack(spacing: 5) {
                        HStack(alignment: .top) {
                            Image("flower")
                                .resizable()
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 4))
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(post.date)
                                        .fontWeight(.bold)
                                }
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
            .onAppear() {
                self.viewModel.getAllPostList()
            }
        }
}

struct SNS_Previews: PreviewProvider {
    static var previews: some View {
        SNS()
    }
}
