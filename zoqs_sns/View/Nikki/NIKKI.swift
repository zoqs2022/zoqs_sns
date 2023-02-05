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
    
    
    var body: some View {
        ZStack{
            
            //backgroundcolor
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            
            //メイン
            VStack {
                Text("Write today's memory")
                    .font(.system(size:30,weight: .heavy))
                    .foregroundColor(.white)
                // 入力
                TextEditor(text: $text)
                    .frame(height: 400)
                    .padding()
                
                
                HStack{
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()//縦横比維持
                            .frame(width: 100)
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                }
            }
        }
        
        
        
        
        
    }
}









struct NIKKI_Previews: PreviewProvider {
    static var previews: some View {
        NIKKI()
    }
}
