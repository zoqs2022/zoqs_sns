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
    
    
    var body: some View {
        VStack{
            HStack(){
                VStack() {
                    if let uiImage = image {
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
            
            ZStack{
                Rectangle()
                    .fill(Color.gray)
                    .frame(height:250)
                VStack{
                    Text("ランダムで背景のアルバム写真が変わる").frame(alignment:.topLeading)
                    Text("〇〇年○月○日")
                }
            }
            VStack{
                Text("写真")
                Text("日記")
                Text("様々なsnsの投稿など")
                Text("その日に起きたこと考えたことが一目で分かるように表示")
            }.padding()
            Spacer()
        }
        .sheet(isPresented: $toEditProfile) {
            EditProfileView(userData: userData)
        }
    }
}

struct PHOTO_Previews: PreviewProvider {
    static var previews: some View {
        PHOTO(userData: UserDataViewModel(model: UserDataModel()))
    }
}
