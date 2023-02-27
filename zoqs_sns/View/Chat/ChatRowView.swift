//
//  ChatRowView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/25.
//

import SwiftUI

let chatMock: [ChatText] = [
    .init(text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaa", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "jpUqvLIs7RhT9WtIfx33knfbYym1", date: Date()),
    .init(text: "aaaaaaaa", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaaaaa", userID: "jpUqvLIs7RhT9WtIfx33knfbYym1", date: Date()),
    .init(text: "aaaaaaaa", userID: "jpUqvLIs7RhT9WtIfx33knfbYym1", date: Date()),
    .init(text: "aaaaaaaa", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
    .init(text: "aaaaabbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: Date()),
]

struct RoomIdAndProfile: Hashable {
    var roomID = ""
    var id: String = ""
    var name: String = ""
    var image: UIImage?
}

class ScrollViewController: ObservableObject {
    @Published var scrollID: Int = 0

    func toBotton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollID = 999
        }
    }
    func resetOffset() {
        self.scrollID = 0
    }
}

struct ChatRowView: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    var otherBasicProfile: BasicProfile
    var roomID: String
    @State private var text = ""
    @FocusState var focus:Bool
    @StateObject var scrollViewController = ScrollViewController()
    
    init(myDataViewModel: MyDataViewModel, roomIdAndProfile: RoomIdAndProfile) {
        self.myDataViewModel = myDataViewModel
        self.otherBasicProfile = .init(id: roomIdAndProfile.id, name: roomIdAndProfile.name, image: roomIdAndProfile.image)
        self.roomID = roomIdAndProfile.roomID
    }
    
    var body: some View {
        VStack(){
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(self.myDataViewModel.model.chats[roomID] ?? []) { chatText in
                            GroupChatRow(myDataViewModel: myDataViewModel, chatText: chatText, otherBasicProfile: otherBasicProfile )
                        }
                    }
                    .padding(.horizontal, 16)
                    .id(999)
                }
                .onTapGesture {
                    self.focus = false
                }
                .onAppear(){
                    withAnimation {
                        proxy.scrollTo(999)
                    }
                }
                .onChange(of: focus) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        withAnimation {
                            proxy.scrollTo(999)
                        }
                    }
                }
                .onChange(of: self.myDataViewModel.model.chats[roomID]?.count) { _ in
                    withAnimation {
                        proxy.scrollTo(999)
                    }
                }
                
            }
            
            HStack{
                TextField("メッセージを入力", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.cyan, lineWidth: 1.0)
                    )
                    .padding(.leading,20)
                    .padding(.vertical, 10)
                    .autocapitalization(.none)
                    .focused(self.$focus)
                Button(action: {
                    myDataViewModel.sendChatMessage(roomID: roomID, text: text)
                    text = ""
                    self.focus = false
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color(.cyan))
                        .font(.system(size: 24))
                    
                }
                .padding(.trailing, 20)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct GroupChatRow: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    var chatText: ChatText
    var otherBasicProfile: BasicProfile

    var body: some View {
        if chatText.userID == myDataViewModel.uid {
            ChatBaloonMy(text: chatText.text,createTime: chatText.date)
                .frame(maxWidth: .infinity, alignment: .trailing)
        } else {
            ChatBaloonOther(myDataViewModel: myDataViewModel,basicProfile: otherBasicProfile, text: chatText.text, createTime: chatText.date)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// メッセージ(相手)
struct ChatBaloonOther: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    var basicProfile: BasicProfile
    var text: String
    var createTime: Date

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // プロフィールアイコン
//            NavigationLink {
//                ProfileView(basicProfile: basicProfile, myDataViewModel: myDataViewModel)
//            } label: {
//                PhotoCircleView(diameter: 40)
//            }
            PhotoCircleView(image: basicProfile.image,diameter: 32)

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .bottom) {
                    // 吹き出し
                    Text(text)
                        .padding(.horizontal,10)
                        .padding(.vertical, 4)
                        .foregroundColor(.white)
                        .background(.gray)
                        .cornerRadius(12)

                    // タイムスタンプ
                    timestamp(date: createTime)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: 200, alignment: .leading)
        }
    }
}

/// メッセージ（自分）
struct ChatBaloonMy: View {
    var text: String
    var createTime: Date

    var body: some View {
        HStack(alignment: .bottom) {
            // タイムスタンプ
            timestamp(date: createTime)
                .multilineTextAlignment(.trailing)

            // 吹き出し
            Text(text)
                .padding(.horizontal,10)
                .padding(.vertical, 4)
                .foregroundColor(.black)
                .background(Color(.cyan))
                .cornerRadius(12)
        }
        .frame(maxWidth: 200, alignment: .trailing)
    }
}

private func timestamp(date: Date) -> some View {
    Text(
        """
        \(date.DateToString(format: "MM/dd"))
        \(date.DateToString(format: "HH:mm"))
        """
    )
    .font(.caption)
    .foregroundColor(Color.gray)
}

struct ChatRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRowView(myDataViewModel: MyDataViewModel(model: MyDataModel()), roomIdAndProfile: .init(roomID: "",id: "jpUqvLIs7RhT9WtIfx33knfbYym1", name: "fffff", image: nil))
    }
}
