//
//  PHOTO.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI



struct PHOTO: View {
    @ObservedObject var userData: UserDataViewModel
    
    @State private var image: UIImage?
    @State var showingImagePicker = false
    @State private var toEditProfile = false
    
    
    @State var focusDate: Int = 0
    
    
    var body: some View {
        ScrollView{
            VStack{
                HStack(){
                    VStack() {
                        if let uiImage = userData.uiImageData {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(Circle())
                        }
                    }
                    VStack(){
                        HStack{
                            Text(userData.name).bold()
                            Spacer()
                            HStack(alignment: .center, spacing: 0){
                                Button(action: {
                                    toEditProfile = true
                                }, label: {
                                    Label("編集", systemImage: "square.and.pencil.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                        .padding(4)
                                        .bold()
                                })
                            }
                            .background(Color(.tertiaryLabel))
                            .cornerRadius(8)
                        }.padding(.leading, 24)
                        
                        Spacer()
                        
                        HStack{
                            VStack{
                                Text("10").bold()
                                Text("投稿").font(.system(size: 12))
                            }
                            Spacer()
                            VStack{
                                Text("100").bold()
                                Text("フォロー中").font(.system(size: 12))
                            }
                            Spacer()
                            VStack{
                                Text("100").bold()
                                Text("フォロワー").font(.system(size: 12))
                            }
                        }.padding(.leading, 40)
                    }.frame(height: 80)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(24)
                
                
                
                
                
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(1..<10){ index in
                            Image("flower")
                                .resizable()//.scaledToFit()
                                .overlay(
                                    // Instagramらしいグラデーション色に!!
                                    Circle().stroke(LinearGradient(gradient: Gradient(colors: [.cyan, .purple, .blue]), startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 5))
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
//                                .frame(width: 100, height: 100)
//                                .clipShape(Circle())
//                                .overlay(RoundedRectangle(cornerRadius: 50)//写真の縁取り、枠を円にする
//                                    .stroke(Color.cyan,lineWidth: 2))
                                .onTapGesture {
                                    focusDate = index
                                }
                        }
                    }
                }
                
                
                
                ZStack{
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:150)
                    VStack{
                        Text("地図表示").frame(alignment:.topLeading)
                        Text("〇〇年○月○日")
                    }
                }
               
                
                
                
                //思い出表示部分
                ZStack{
                    Rectangle()
                        .fill(Color.mint.opacity(0.2))
                    VStack(alignment: .leading){
                        VStack{//日付と日記
                            //Text("Memory in   \(textMonth).\(textDay).\(textYear)").font(.title2).fontWeight(.bold).padding(.bottom,10)
                            Text("Memory in   \(focusDate)番目の写真の日付").font(.title2).fontWeight(.bold).padding()
                            
                            VStack{
                                Text("日記の表示")
                                Image("flower")
                                    .resizable()
                                    .scaledToFit()//縦横比維持
                                    .frame(width: 200)
                            }
                            
                        }
                        
                        HStack(alignment: .top){//メタ情報
                            VStack(alignment: .leading){
                                Text("with").font(.headline)
                                Text("at").font(.headline)
                                Text("play music").font(.headline)
                                Text("contact").font(.headline)
                                Text("sns").font(.headline)
                                
                            }
                            VStack(alignment: .leading){
                                Text("alone")
                                Text("ドイツ")
                                Text("Norwegian Wood")
                                Text("連絡を取った人のリスト")
                                Text("他のsnsの投稿を見れる")
                                
                            }
                        }
                    }//日記表示全体のvstack,textとif
                }//背景色と日記のzstak
                
                
                Spacer()
            }
            .sheet(isPresented: $toEditProfile) {
                EditProfileView(userData: userData)
            }
        }
    }
}









struct PHOTO_Previews: PreviewProvider {
    static var previews: some View {
        PHOTO(userData: UserDataViewModel(model: UserDataModel()))
    }
}
