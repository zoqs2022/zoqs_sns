//
//  ContentView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData = UserDataViewModel(model: UserDataModel())
    
    @Binding var isActive: Bool
    // xOffset変数で画面の横のオフセットを保持します
    @State private var xOffset = CGFloat.zero
    @State private var defaultOffset = CGFloat.zero
    @State private var variableOffset = CGFloat.zero
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            // スワイプが検知されたときの動きを実装します
            .onChanged{ value in
                if (self.xOffset != .zero && value.translation.width > 0 && self.xOffset <= 0) {
                    self.xOffset = self.variableOffset + value.translation.width
                } else if (self.xOffset != self.defaultOffset && value.translation.width < 0 && self.xOffset >= self.defaultOffset) {
                    self.xOffset = self.variableOffset + value.translation.width
                }
            }
        
            // スワイプが終了したときの動きを実装します
            .onEnded { value in
                withAnimation() {
                    // もし、右方向にスワイプした距離が5以上ならオフセットを0にします
                    // すなわち、メニューを表示します
                    // それ以外はオフセットをスライドメニュー分設定します
                    // すなわちスライドメニューを隠します
                    if (value.translation.width > 5) {
                        self.xOffset = .zero
                        self.variableOffset = .zero
                    } else {
                        self.xOffset = self.defaultOffset
                        self.variableOffset = self.defaultOffset
                    }

                }
            }
    }
    
    var body: some View {
        // 画面サイズの取得にGeometoryReaderを利用します
        GeometryReader { geometry in
                HStack(spacing: 0) {
                    MenuView(userData: userData)
                        // 横幅は画面サイズの70%にします
                        .frame(width: geometry.size.width * 0.7)
                    Divider()
                    MainView( userData: userData, isActive: $isActive, xOffset: $xOffset.animation(), defaultOffset: $defaultOffset.animation())
                        // 横幅は画面サイズの100%にします
                        .frame(width: geometry.size.width)
                }
                // 最初に画面のオフセットの値をスライドメニュー分マイナスします。
                .onAppear(perform: {
                    self.xOffset = geometry.size.width * -0.7
                    self.defaultOffset = self.xOffset
                    self.variableOffset = self.xOffset
                })
                .offset(x: self.xOffset)
                // 画面サイズを明示します
                .frame(width: geometry.size.width, alignment: .leading)
                .gesture(
                    self.dragGesture
                )
                .onAppear {
                    print("USER_ID: "+userData.uid)
                    userData.getUserName()
                    userData.getUserImageData()
                }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    @State private var isActive = true
//    
//    static var previews: some View {
//        ContentView(isActive: $isActive)
//    }
//}
