//
//  NIKKI.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import FirebaseFirestore

struct NIKKI: View {
    
    
    
    //firebase
    let db = Firestore.firestore()
    
    func CreateAddFirebase(text:String,feeling:Int,with:Int) {
        var ref: DocumentReference? = nil
        ref = db.collection("post").addDocument(data: [
            "userID": AuthHelper().uid(),
            "date": Timestamp(),
            "feeling":feeling,
            "text":text,
            "with":with
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
   
    let withList = ["友達","恋人","家族","知人","一人"]
    let tempList = ["楽しい","嬉しい","幸せ","憂鬱","悲しい","不安","怒り","疲れた","爽やか","イライラ"]
    
    
    @State var text: String = ""
    @State var feeling: Int = 0
    @State var with: Int = 0
    @State var temp: Int = 0
    
    @State private var image: UIImage?
    @State var showingImagePicker = false
    
    let ScreenWidth = (UIScreen.main.bounds.width)*0.9
    
    
    var body: some View {
        ZStack{
            
            //backgroundcolor
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            
            //メイン
            ScrollView{
                VStack {
                    Text("Write today's memory")
                        .font(.system(size:30,weight: .heavy))
                        .foregroundColor(.white)
                    
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
                                                temp = index*5+i
                                            }, label: {
                                                Image(systemName: "face.smiling")
                                                    .resizable()
                                                    .frame(width: 30 ,height: 30)
                                                    .foregroundColor(temp == index*5+i ? .red: .blue)
                                            })
                                            Text(tempList[index*5+i])
                                        }//vstack item
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
                                        Text(withList[index])
                                    }
                                }//foreach
                                Spacer()
                            }//hstack
                        }.padding()
                    }//zstack
                    
                    
                    // 入力
                    TextEditor(text: $text)
                        .frame(width: ScreenWidth, height: 150)
                        .padding()
                        
                    
                    
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
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                    }
                    
                    
                    Button(action: {
                        CreateAddFirebase(text: text, feeling: feeling, with: with)
                    }, label: {
                        Text("投稿する").font(.title2).padding().background(Color.white).cornerRadius(20).padding()
                    })
                    
                    
                    
                }//全体のvstack
            }//scrollview
        }//zstack
        
        
        
        
        
    }
}









struct NIKKI_Previews: PreviewProvider {
    static var previews: some View {
        NIKKI()
    }
}
