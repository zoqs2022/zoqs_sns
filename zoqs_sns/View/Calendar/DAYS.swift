//
//  DAYS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//


//日記仮データ
let nikki:[String:String] = [
    "2-1":"僕は三十七歳で、そのときボーイング747のシートに座っていた。その巨大な飛行機はぶ厚い雨雲をくぐり抜けて降下し、ハンブルク空港に着陸しようとしているところだった。十一月の冷ややかな雨が大地を黒く染め、雨合羽を着た整備工たちや、のっぺりとした空港ビルの上に立った旗や、BMWの広告板やそんな何もかもをフランドル派の陰うつな絵の背景のように見せていた。やれやれ、またドイツか、と僕は思った。",
    "2-14":"「ではみなさんは、そういうふうに川だと云いわれたり、乳の流れたあとだと云われたりしていたこのぼんやりと白いものがほんとうは何かご承知ですか。」先生は、黒板に吊つるした大きな黒い星座の図の、上から下へ白くけぶった銀河帯のようなところを指さしながら、みんなに問といをかけました。",
    "2-17":"国境の長いトンネルを抜けると雪国であった。夜の底が白くなった。信号所に汽車が止まった。",
    "2-22":"私は、その男の写真を三葉、見たことがある。一葉は、その男の、幼年時代、と言うべきであろうか、十歳前後かと推定される頃の写真であって、その子供が大勢の女のひとに取りかこまれ、(それは、その子供の姉たち、妹たち、それから、従姉妹たちかと想像される)庭園の池のほとりに、荒い縞の袴をはいて立ち、首を三十度ほど左に傾け、醜く笑っている写真である。",
    "2-24":"幼時から父は、私によく、金閣のことを語った。私の生れたのは、舞鶴から東北の、日本海へ突き出たうらさびしい岬である。",
    "2-26":"「完璧な文章などといったものは存在しない。完璧な絶望が存在しないようにね」",
    "2-10":"さびしさは鳴る。耳が痛くなるほど高く澄んだ鈴の音で鳴り響いて、胸を締めつけるから、せめて周りには聞こえないように、私はプリントを指で千切る。",
]





import SwiftUI

struct DAYS: View {
    //画面下部に表示する日付
    @State var textYear:String = Date().DateToString(format: "y")
    @State var textMonth:String = Date().DateToString(format: "M")
    @State var textDay:String = Date().DateToString(format: "d")
    
    var body: some View {
        
        VStack{//広告とスクロールビューのvstack
//            AdBanner(adUnitId:MyId,widthSize: 320,heightSize: 50).expectedFrame()
            ScrollView{
                AdBanner(adUnitId:MyId,widthSize: 320,heightSize: 50).expectedFrame()
                //カレンダー部分
                CalendarView(textYear: $textYear, textMonth: $textMonth, textDay: $textDay)
                //思い出表示部分
                CalendarNikki(textYear: $textYear, textMonth: $textMonth, textDay: $textDay)
            }//スクロールビュー、カレンダー部分と試合予定全体をくくる
        }//広告とスクロールビューのvstack
    }
}





struct CalendarView : View {
    
    @State var date = Date()
    let week: [String] = ["日","月","火","水","木","金","土"]
    @State var diff: Int = 0
    let today: Int = Int(Date().DateToString(format: "d"))! - 1
    
    @Binding var textYear: String
    @Binding var textMonth: String
    @Binding var textDay: String
    
    
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
                                            textDay = days[i].DateToString(format: "d")
                                            textMonth = Date().changeMonth(diff: diff).DateToString(format: "M")
                                            textYear = Date().changeMonth(diff: diff).DateToString(format: "y")
                                        }
                                    Text(days[i].DateToString(format: "d"))
                                } else {//今日以外の全ての日
                                    //日記を書いた日は背景色を濃くする
                                    if(nikki.keys.contains(Date().changeMonth(diff: diff).DateToString(format: "M")+"-"+days[i].DateToString(format: "d"))){
                                        //試合有りの場合
                                        Circle()
                                            .frame(width: 46, height: 46, alignment: .center)
                                            .foregroundColor(.cyan)
                                            .opacity(0.9)
                                            .onTapGesture {
                                                textDay = days[i].DateToString(format: "d")
                                                textMonth = Date().changeMonth(diff: diff).DateToString(format: "M")
                                                textYear = Date().changeMonth(diff: diff).DateToString(format: "y")
                                            }
                                        Text(days[i].DateToString(format: "d"))
                                    } else {
                                        //日記なしの日は背景色を薄くす
                                        Circle()
                                            .frame(width: 46, height: 46, alignment: .center)
                                            .foregroundColor(.mint)
                                            .opacity(0.3)
                                            .onTapGesture {
                                                textDay = days[i].DateToString(format: "d")
                                                textMonth = Date().changeMonth(diff: diff).DateToString(format: "M")
                                                textYear = Date().changeMonth(diff: diff).DateToString(format: "y")
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
    
    @Binding var textYear:String
    @Binding var textMonth:String
    @Binding var textDay:String
    
    var body : some View {
        
        //思い出表示部分
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.cyan.opacity(0.3), .cyan]), startPoint: .top, endPoint: .bottom)
            
            VStack(){
                VStack{//日付と日記
                    Text("Memory in   \(textMonth).\(textDay).\(textYear)").font(.title2).fontWeight(.bold).padding()
                    
                    if(nikki.keys.contains(textMonth+"-"+textDay)){//日記がある場合、日記と写真を表示
                        VStack{
                            Text(nikki[textMonth+"-"+textDay]!)
                            Image("flower")
                                .resizable()
                                .scaledToFit()//縦横比維持
                                .frame(width: 200)
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
