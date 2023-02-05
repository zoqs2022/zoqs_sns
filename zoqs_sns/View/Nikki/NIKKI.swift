//
//  NIKKI.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI

struct NIKKI: View {
    
    @State var text: String = ""
    
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
                                        print("click")
                                    }, label: {
                                        Image(systemName: "face.smiling")
                                            .resizable()
                                            .frame(width: 30 ,height: 30)
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
                            ForEach(0..<3, id: \.self){ index in
                                HStack{
                                    ForEach(0..<5, id: \.self) { index in
                                        VStack{
                                            Button(action: {
                                                print("click")
                                            }, label: {
                                                Image(systemName: "face.smiling")
                                                    .resizable()
                                                    .frame(width: 30 ,height: 30)
                                            })
                                            Text("楽しい")
                                        }//vstack item
                                    }//foreach
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
                                            print("click")
                                        }, label: {
                                            Image(systemName: "face.smiling")
                                                .resizable()
                                                .frame(width: 30 ,height: 30)
                                        })
                                        Text("友達")
                                    }
                                }//foreach
                                Spacer()
                            }//hstack
                        }.padding()
                    }//zstack
                    
                    
                    // 入力
                    TextEditor(text: $text)
                        .frame(width: ScreenWidth, height: 200)
                        .padding()
                        
                    
                    
                    HStack{
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()//縦横比維持
                                .frame(width: 100)
                                .background(Color.white)
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                    }
                }
            }//scrollview
        }//zstack
        
        
        
        
        
    }
}









struct NIKKI_Previews: PreviewProvider {
    static var previews: some View {
        NIKKI()
    }
}
