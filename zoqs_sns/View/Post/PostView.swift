//
//  NIKKI.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import FirebaseFirestore

struct PostView: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    @FocusState var focus:Bool
    
    private static let placeholder = "自由に入力してください"
    @State private var placeholderText = placeholder
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
    var ActiveButtonOpacity: Double {
        get{
            return isActiveButton ? 1.0 : 0.3
        }
    }
    
    let withList = ["友達","恋人","家族","知人","一人"]
    let tempList = ["楽しい","嬉しい","幸せ","憂鬱","悲しい","不安","怒り","疲れた","爽やか","イライラ"]
    let ScreenWidth = (UIScreen.main.bounds.width)*0.9
    
    
    
    var body: some View {
        ZStack(alignment: .top){
            
            //backgroundcolor
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: [.top])
            //メイン
            ScrollView{
                VStack {
                    Text("Write today's memory")
                        .font(.system(size:30,weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    HStack{
                        VStack{
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()//縦横比維持
                                    .frame(width: 50)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .frame(width: 80, height: 80, alignment: .center)
                        .background(Color(.cyan))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                        }
                        if let uiImage = image {
                            VStack{
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()//縦横比維持
                                    .frame(height: 120)
                                    .cornerRadius(20)
                            }
                            .padding(16)
                        }
                    }.frame(height: 140)
                
                    // 入力
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .strokeBorder().foregroundColor(.gray)
                            .background(Color.clear)
                        TextEditor(text: $text)
                            .padding(10)
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                            .onChange(of: text) { value in
                                if text.isEmpty {
                                    placeholderText = Self.placeholder
                                } else {
                                    placeholderText = ""
                                }
                            }
                            .focused(self.$focus)
                        Text(placeholderText)
                            .padding(16)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .frame(width: ScreenWidth, height: 120)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                        
                    //feeling入力画面
                    ButtonIcon(feeling: $feeling, emotion: $emotion, with: $with)
                    
                    VStack{
                        Button(action: {
                            if loading {return}
                            loading = true
                            myDataViewModel.createPost(text: text, feeling: feeling, emotion: emotion, with: with, image: image, result: { err in
                                if let err = err {
                                    errorMessage = err
                                    isAlert = true
                                } else {
                                    image = nil
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
                            VStack{
                                if loading {
                                    LoadingView()
                                        .padding(.horizontal, 8)
                                } else {
                                    Text("投稿する")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: ScreenWidth,height: 40)
                            .background(Color(.cyan))
                            .cornerRadius(20)
                            .opacity(ActiveButtonOpacity)
                        })
                        .disabled(!isActiveButton)
                    }
                    .padding()
                }//scrollview
            }
            .onTapGesture {
                self.focus = false
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



struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(myDataViewModel: MyDataViewModel(model: MyDataModel()))
    }
}
