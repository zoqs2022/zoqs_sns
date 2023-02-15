//
//  MenuView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/19.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if let uiImage = userViewModel.model.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            Text("SwiftUIへの道")
                .font(.largeTitle)
            Text("@road2swiftui")
                .font(.caption)
            Divider()
            ScrollView (.vertical, showsIndicators: true) {
                HStack {
                    Image(systemName: "person")
                    Text("Profile")
                }
                HStack {
                    Image(systemName: "list.dash")
                    Text("Lists")
                }
                HStack {
                    Image(systemName: "text.bubble")
                    Text("Topics")
                }
            }
            Divider()
            Text("Settings and privacy")
        }
        .padding(.horizontal, 20)
    }
}


//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
