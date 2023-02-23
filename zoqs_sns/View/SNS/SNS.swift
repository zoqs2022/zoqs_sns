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
                            Text(String(post.date.DateToString(format: "yyyy/MM/dd HH:mm:ss"))).foregroundColor(.gray)
                            Text(post.text)
//                            if let image = post.postImage {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(height: 200)
//                                    .cornerRadius(20)
//                            }
//                            Image("flower")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 200)
//                                .cornerRadius(20)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity, minHeight: 60, alignment: .top)
                Divider()
            }
        }
    }
}

let postsMock: [PostModel] = [
    PostModel(id: "0", text: "aaaa", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date(), userName: "aaaa"),
    PostModel(id: "1", text: "bbbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date(), userName: "aaaa"),
    PostModel(id: "2", text: "cccc", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date(), userName: "aaaa"),
    PostModel(id: "3", text: "dddd", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date(), userName: "aaaa"),
    PostModel(id: "4", text: "eeee", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date(), userName: "aaaa"),
]

struct SNS_Previews: PreviewProvider {
    static var previews: some View {
        SNS(postViewModel: PostViewModel(model: postsMock))
    }
}
