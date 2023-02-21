//
//  DAYS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//



import SwiftUI

struct DAYS: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    //画面下部に表示する日付
    @State var textDate:String = Date().DateToString(format: "yyyy/MM/dd")
    
    var body: some View {
        
        VStack{//広告とスクロールビューのvstack
//            AdBanner(adUnitId:MyId,widthSize: 320,heightSize: 50).expectedFrame()
            ScrollView{
                //カレンダー部分
                CalendarView(myDataViewModel: myDataViewModel, textDate:$textDate)
                //思い出表示部分
                CalendarNikki(myDataViewModel: myDataViewModel, textDate:$textDate)
            }//スクロールビュー、カレンダー部分と試合予定全体をくくる
        }//広告とスクロールビューのvstack
    }
}





struct CalendarView : View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    @State var date = Date()
    let week: [String] = ["日","月","火","水","木","金","土"]
    @State var diff: Int = 0
    let today: Int = Int(Date().DateToString(format: "d"))! - 1
    
    @Binding var textDate: String
    
    
    var body: some View {
        
        VStack{//月の前後ボタンとカレンダーのvstack
            HStack{//月の表示と前後ボタン
                Button(action: {diff -= 1}, label: {Image(systemName: "chevron.left.circle.fill")}).foregroundColor(.blue)
                Text(Date().changeMonth(diff: diff).DateToString(format: "yyyy年M月")).fontWeight(.bold)
                Button(action: {diff += 1}, label: {Image(systemName: "chevron.right.circle.fill")}).foregroundColor(.blue)
            }
            ScrollView{//カレンダー部分
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7))
                {
                    ForEach(week, id: \.self) { i in //画面上部の曜日表示
                        Text(i).foregroundColor(.blue).fontWeight(.bold).padding(.top)
                    }
                    
                    let days: [Date] = Date().changeMonth(diff: diff).getAllDays()
                    let start = days[0].getWeekDay()
                    let end = start + days.count
                    
                    let maxBlock: Int = end <= 35 ? 34 : 41
                    
                    ForEach((0...maxBlock), id: \.self) { index in
                        ZStack{
                            if(index >= start && index < end){
                                let i = index - start
                                if(i == today && diff == 0) {//今日当日、背景色を濃くする
                                    Circle()
                                        .frame(width: 46, height: 46, alignment: .center)
                                        .foregroundColor(.blue)
                                        .opacity(1)
                                        .onTapGesture {
                                            textDate = days[i].DateToString(format: "yyyy/MM/dd")
                                        }
                                    Text(days[i].DateToString(format: "d"))
                                } else {//今日以外の全ての日
                                    //日記を書いた日は背景色を濃くする
                                    if(myDataViewModel.model.posts.contains(where: {$0.date.DateToString(format: "yMd") == days[i].DateToString(format: "yMd")})) {
                                        //試合有りの場合
                                        Circle()
                                            .frame(width: 46, height: 46, alignment: .center)
                                            .foregroundColor(.cyan)
                                            .opacity(0.9)
                                            .onTapGesture {
                                                textDate = days[i].DateToString(format: "yyyy/MM/dd")
                                            }
                                        Text(days[i].DateToString(format: "d"))
                                    } else {
                                        //日記なしの日は背景色を薄くす
                                        Circle()
                                            .frame(width: 46, height: 46, alignment: .center)
                                            .foregroundColor(.mint)
                                            .opacity(0.3)
                                            .onTapGesture {
                                                textDate = days[i].DateToString(format: "yyyy/MM/dd")
                                            }
                                        Text(days[i].DateToString(format: "d"))
                                    }//日記の有無のif
                                }//今日かそれ以外かのif
                            }//if 日付が存在するか
                        }//zstack　背景と日付重ねる
                    }//foreach
                }//グリッド
            }//スクロールビュー、カレンダー部分
        }.padding(.horizontal, 10)//月の前後ボタンとカレンダーのvstack
        
    }
}







struct CalendarNikki : View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    @Binding var textDate: String
    let posts: [PostData]
    
    init(myDataViewModel: MyDataViewModel, textDate: Binding<String>) {
        self.myDataViewModel = myDataViewModel
        self._textDate = textDate
        posts = myDataViewModel.model.posts.filter({ $0.date.DateToString(format: "yyyy/MM/dd") == textDate.wrappedValue })
    }
    
    var body : some View {
        
        //思い出表示部分
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.cyan.opacity(0.3), .cyan]), startPoint: .top, endPoint: .bottom)
            
            VStack(){
                VStack{//日付と日記
                    Text("Memory in   \(textDate)").font(.title2).fontWeight(.bold).padding()
                    if(!posts.isEmpty){//日記がある場合、日記と写真を表示
                        ForEach(posts, id: \.id) { post in
                            VStack{
                                Text(post.text)
                                Image("flower")
                                    .resizable()
                                    .scaledToFit()//縦横比維持
                                    .frame(width: 200)
                            }
                        }
                    }
                }
                
                HStack(alignment: .top){//メタ情報
                    VStack(alignment: .leading){
                        Text("feeling").font(.headline).foregroundColor(.cyan)
                        Text("with").font(.headline).foregroundColor(.cyan)
                        Text("at").font(.headline).foregroundColor(.cyan)
                        Text("play music").font(.headline).foregroundColor(.cyan)
                        Text("contact").font(.headline).foregroundColor(.cyan)
                        Text("sns").font(.headline).foregroundColor(.cyan)
                    }
                    VStack(alignment: .leading){
                        Text("😀")
                        Text("alone")
                        Text("ドイツ")
                        Text("Norwegian Wood")
                        Text("連絡を取った人のリスト")
                        Text("他のsnsの投稿を見れる")
                        
                    }
                }.padding().background(Color.white).cornerRadius(10).padding()
            }//.padding().background(Color.mint.opacity(0.2)).padding()//日記表示全体のvstack,textとif
        }//zstack、背景と日記
        
        
    }
}
