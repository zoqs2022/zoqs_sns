//
//  NIKKI.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import FirebaseFirestore

struct NIKKI: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    
    @State var text: String = ""
    @State var feeling: Int = 0
    @State var with: Int = 0
    @State var emotion: Int = 0
    @State private var image: UIImage?
    
    @State var showingImagePicker = false
    @State var loading = false
    @State var isSuccessed = false
    @State private var isAlert = false
    @State private var errorMessage = ""
    var isActiveButton: Bool {
        get{
            return text != ""
        }
    }
    
    let withList = ["友達","恋人","家族","知人","一人"]
    let tempList = ["楽しい","嬉しい","幸せ","憂鬱","悲しい","不安","怒り","疲れた","爽やか","イライラ"]
    let ScreenWidth = (UIScreen.main.bounds.width)*0.9
    
    
    
    var body: some View {
        ZStack(alignment: .top){
            
            //backgroundcolor
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan, .blue]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
            //メイン
            ScrollView{
                VStack {
                    Text("Write today's memory")
                        .font(.system(size:30,weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    //feeling入力画面
                    ButtonIcon(feeling: $feeling, emotion: $emotion, with: $with)
                    
                    
                    // 入力
                    TextEditor(text: $text)
                        .frame(width: ScreenWidth, height: 150)
                        .padding()
                        .autocapitalization(.none)
                        
                    
                    
                    HStack{
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()//縦横比維持
                                .frame(width: 30)
                                .background(Color.white)
                        }
                    }
                    .padding(4)
                    .cornerRadius(4)
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                    }
                    
                    
                    Button(action: {
                        if loading {return}
                        loading = true
                        myDataViewModel.createPost(text: text, feeling: feeling, emotion: emotion, with: with, image: image, result: { err in
                            if let err = err {
                                errorMessage = err
                                isAlert = true
                            } else {
                                text = ""
                                feeling = 0
                                emotion = 0
                                with = 0
                                isSuccessed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    isSuccessed = false
                                }
                            }
                            loading = false
                        })
                    }, label: {
                        Group{
                            if loading {
                                LoadingView()
                            } else {
                                Text("投稿する").font(.title2).padding().background(Color.white).cornerRadius(20).padding().shadow(radius: 20)
                            }
                        }
                    })
                    .disabled(!isActiveButton)
                }//scrollview
            }
            if isSuccessed {
                VStack(alignment: .center){
                    Text("投稿しました")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .bold()
                        .padding(4)
                }
                .frame(maxWidth: .infinity)
                .background(.gray)
            }
        }//zstack
        .alert(isPresented: $isAlert){
            Alert(title: Text("エラー"),message: Text(errorMessage))
        }
    }
}



struct ButtonIcon : View {
    
    let ScreenWidth = (UIScreen.main.bounds.width)*0.9
    
    @Binding var feeling:Int
    @Binding var emotion:Int
    @Binding var with:Int
    let withList = ["友達","恋人","家族","知人","一人"]
    let emotionList = ["楽しい","嬉しい","幸せ","憂鬱","悲しい","不安","怒り","疲れた","爽やか","イライラ"]
    
    
    var body: some View {
        
        //feeling入力画面
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: ScreenWidth)
            VStack{
                Text("今日はどんな一日でしたか？").font(.headline)
                HStack{
                    ForEach(0..<5, id: \.self) { index in
                        Spacer()
                        Button(action: {
                            feeling = index
                        }, label: {
                            Image(systemName: "face.smiling")
                                .resizable()
                                .frame(width: 30 ,height: 30)
                                .foregroundColor(feeling == index ? .red : .blue)
                        })
                    }//foreach
                    Spacer()
                }//hstack
            }.padding()
        }//zstack
        
        
        //feeling2
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: ScreenWidth)
            VStack{
                Text("今日の気分は？").font(.headline)
                ForEach(0..<2, id: \.self){ index in
                    HStack{
                        ForEach(0..<5, id: \.self) { i in
                            Spacer()
                            VStack{
                                Button(action: {
                                    emotion = index*5+i
                                }, label: {
                                    Image(systemName: "face.smiling")
                                        .resizable()
                                        .frame(width: 30 ,height: 30)
                                        .foregroundColor(emotion == index*5+i ? .red: .blue)
                                })
                                Text(emotionList[index*5+i]).font(.caption)
                            }.frame(width:ScreenWidth/8)//vstack item
                        }//foreach
                        Spacer()
                    }//hstack
                }//foreach
            }.padding()
        }//zstack
        
        
        //meet
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: ScreenWidth)
            VStack{
                Text("誰といた？").font(.headline)
                HStack{
                    ForEach(0..<5, id: \.self) { index in
                        Spacer()
                        VStack{
                            Button(action: {
                                with = index
                            }, label: {
                                Image(systemName: "face.smiling")
                                    .resizable()
                                    .frame(width: 30 ,height: 30)
                                    .foregroundColor(with == index ? .red : .blue)
                            })
                            Text(withList[index]).font(.caption)
                        }
                    }//foreach
                    Spacer()
                }//hstack
            }.padding()
        }//zstack
    }
}







//struct NIKKI_Previews: PreviewProvider {
//    static var previews: some View {
//        NIKKI()
//    }
//}
