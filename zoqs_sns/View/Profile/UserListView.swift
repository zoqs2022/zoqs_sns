//
//  UserListView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import SwiftUI

struct SampleUserData: Identifiable {
    var id: String
    var name: String
    var image: UIImage?
}
private let sampleUserData: [SampleUserData] = [
    .init(id: "1", name: "4rfv"),
    SampleUserData(id: "2", name: "ssss"),
    SampleUserData(id: "6", name: "12345"),
    SampleUserData(id: "9", name: "asdfghj"),
]


struct UserListView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            List {
                ForEach(sampleUserData, id: \.id) { (user) in
                    NavigationLink(destination: ProfileView(accountId: user.id) ) {
                        HStack(alignment: .top) {
                            PhotoCircleView(image: user.image, diameter: 40)
                            VStack(alignment: .leading) {
                                Text("\(user.name)")
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.horizontal, 0)
                        Text("\(user.name)")
                    }
                }
            }
            
            Button(action: {
                dismiss()
            }, label: {
                Text("戻るボタン")
            })
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
