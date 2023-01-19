//
//  SNS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import FirebaseFirestore

struct Timeline {
    let id: Int
    let name: String
    let image: String
    let post: String
    let post_image: String
}

let timelines: [Timeline] = [
    Timeline(id: 0, name: "Arupaka", image: "flower", post: "This is post content", post_image: "flower"),
    Timeline(id: 1, name: "Buta", image: "flower", post: "This is post content", post_image: "flower"),
    Timeline(id: 2, name: "Hamster", image: "flower", post: "This is post content", post_image: "flower"),
    Timeline(id: 3, name: "Hiyoko", image: "flower", post: "This is post content", post_image: "flower"),
    Timeline(id: 4, name: "Inu", image: "flower", post: "This is post content", post_image: "flower")
]

struct SNS: View {
    @State var testArr:[String] = []
    
    var body: some View {
            VStack() {
                ForEach(timelines, id: \.id) { (timeline) in
                    VStack(spacing: 5) {
                        HStack(alignment: .top) {
                            Image(timeline.image)
                                .resizable()
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 4))
                                .frame(width: 60, height: 60)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(timeline.name)
                                        .fontWeight(.bold)
                                    Text("@\(timeline.name)")
                                        .foregroundColor(.gray)
                                }
                                Text(timeline.post)
                                Image(timeline.post_image)
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

struct SNS_Previews: PreviewProvider {
    static var previews: some View {
        SNS()
    }
}
