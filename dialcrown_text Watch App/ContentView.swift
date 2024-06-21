//
//  ContentView.swift
//  dialcrown_text Watch App
//
//  Created by shirane kaoru on 2023/12/05.
//

import SwiftUI
import WatchConnectivity
import Foundation

struct SeedableRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
var vowels:[String] = ["あ行","か行","さ行","た行","な行","は行","ま行","や行","ら行","わ行","\",゜"]

//var vowels:[String] = ["あ","か","さ","た","な","は","ま","や","ら","わ","\",゜"]

var consonant: [[String]] = [
    ["あ","い","う","え","お"],
    ["か","き","く","け","こ"],
    ["さ","し","す","せ","そ"],
    ["た","ち","つ","て","と"],
    ["な","に","ぬ","ね","の"],
    ["は","ひ","ふ","へ","ほ"],
    ["ま","み","む","め","も"],
    ["や","ゆ","よ"],
    ["ら","り","る","れ","ろ"],
    ["わ","を","ん"],
    ["\"","゜","小"]
]


var henkan : [String:[String]] = ["あ":["ぁ","あ"],"い":["ぃ","い"],"う":["ぅ","う"],"え":["ぇ","え"],"お":["ぉ","お"],"か":["が","か"],"き":["ぎ","き"],"く":["ぐ","く"],"け":["げ","け"],"こ":["ご","こ"],"さ":["ざ","さ"],"し":["じ","し"],"す":["ず","す"],"せ":["ぜ","せ"],"そ":["ぞ","そ"],"は":["ば","ぱ","は"],"ひ": ["び","ぴ","ひ"],"ふ":["ぶ","ぷ","ふ"],"へ":["べ","ぺ","へ"],"ほ":["ぼ","ぽ","ほ"],"た":["だ","た"],"ち":["ぢ","ち"],"つ":["っ","づ","つ"],"て":["で","て"],"と":["ど","と"],"や":["ゃ","や"],"ゆ":["ゅ","ゆ"],"よ":["ょ","よ"],"わ":["ゎ","わ"],]

// 入力フレーズ

//var r_phrase: [String] = [
//    "おはよう",
//    "こんにちは",
//    "こんばんわ",
//    "おやすみ",
//    "げんきです",
//    "ねむいです",
//    "さようなら",
//    "ひさしぶり",
//    "やっぱいいや",
//    "どうでもいいよ",
//    "すごくいいね",
//    "おなかすいた",
//    "べんきょうする",
//    "きたくします",
//    "ただいま",
//    "ばんごはんなに",
//    
//]

var phrase: [String] = [
"あしたはかいぎ",
"しめきりがちかい",
"ごごきゅうこう",
"ろんぶんよむ",
"いんたらくしょん",
"れんしゅうする",
"すいどうだい",
"やさいをとる",
"ていしゅつきげん",
"ふみんふきゅう",
"そうじとうばん",
"ことしきせいする",
"どうもありがとう",
"わかりました",
"ごめんなさい",
"てんきわるい",
"きょうははれ",
"だいがくにいく",
"おなかすいた",
"すいみんをとる",
"おひさしぶり",
"おつかれさま",
"めんどくさい",
"かぜをひいた",
"いまどこにいる",
"きどくがつく",
"ききかんをもつ",
"ぷろぐらみんぐ",
"つうわをする",
"きをつけてね",
"えきについた",
"らくたんしてた",
"たんいをとる",
"そつぎょうする",
"けんきゅうしつ",
"ひるめしたべた",
"ひるねをする",
"りしゅうとうろく",
"やちんをはらう",
"りんじんとらぶる",
"ぽいんとをためる",
"すたんぷをつかう",
"あしたよていある",
"がぞうをほぞん",
"らいんをかえす",
"こうぎのめも",
"ほんをよんでた",
"きょうしつにいく",
"じゅうでんきどこ",
"まうすでそうさ",
"すまほわすれた",
"ゆめをみる",
"ぬれたしゃつ",
"へんしんする",
//"つくばだいがく",
//"じてんしゃのる",
//"ぱわぽをつかう",
//"あしたあそぼ",
//"あしたはくもり",
//"あきたにいく",
//"なまはげをみる",
//"あしたはあめ",
//"うるしをぬる",
//"あしたはやすみ",
]

var offset_vowel_angle: CGFloat = 360.0 / 11.0
var offset_cons_angle: CGFloat = 360.0 / 5.0
var start_angle: CGFloat = 0.0
var padding_angle: CGFloat = 1.0
let CenterX:CGFloat = 86.0
let CenterY:CGFloat = 69.0
let MAX_WIDTH:CGFloat = 172.0 - 20
let MAX_HEIGHT:CGFloat = 138.0
let length: CGFloat = 40
let vowel_size:Int = 11

//パラメータを調整できるView
struct ConfigView: View{

    
    @Binding var CROWN_SPEED: Double
    @Binding var DECISION_TIME: Double
    var body: some View{

        List{
            
            Text("回転感度:\(CROWN_SPEED)")
            Slider(value: $CROWN_SPEED, in:3...5, step:1)
            Text("決定時間:\(DECISION_TIME)")
            Slider(value: $DECISION_TIME, in:0.0...0.4, step:0.2)


        }.navigationTitle("config")
    }

}

struct StartListView: View {
    

    @State private var CROWN_SPEED = 3.0
    @State private var DECISION_TIME = 0.0
    var body: some View {
        NavigationView{
            List{
                NavigationLink(
                    destination: ConfigView(CROWN_SPEED: $CROWN_SPEED,DECISION_TIME: $DECISION_TIME),
                    label: {Text("config")})
                NavigationLink(
                    destination: TestView(CROWN_SPEED: $CROWN_SPEED,DECISION_TIME: $DECISION_TIME),
                    label: {Text("動作確認")})
                NavigationLink(
                    destination: PracticeView(CROWN_SPEED: $CROWN_SPEED,DECISION_TIME: $DECISION_TIME),
                    label: {Text("practice")})
//                NavigationLink(
//                    destination: Type1(),
//                    label: {Text("TouchCrown")})
                NavigationLink(
                    destination: DialCrownView(CROWN_SPEED: $CROWN_SPEED,DECISION_TIME: $DECISION_TIME),
                    label: {Text("BlackDialCrown")})
                
                    
                
            }.navigationTitle("Option")
        }
    }
}


struct DialCrownView: View {
    @Binding var CROWN_SPEED: Double
    @Binding var DECISION_TIME: Double
    
    @State private var degital_rotate: CGFloat = 0.0
    @State private var crownSpeed:CGFloat = 0.0
    @State private var lastUpdateTime = Date()
    private let updateThreshold = 0.1 // Digital Crownの回転が止まったとみなす秒数
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect() // 0.1秒ごとにタイマーイベントを発行
    @State private var circlePositionX: CGFloat = length * cos(270 * Double.pi / 180.0) + CenterX
    @State private var circlePositionY: CGFloat = length * sin(270 * Double.pi / 180.0) + CenterY
    
    
    @State private var bar_color = [Color.red,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white]
    
    @State private var bar_cons_color = [Color.red,Color.white,Color.white,Color.white,Color.white]
    
    // 子音および母音をさすインデックス
    @State private var vowel_index = 0
    @State private var cons_index = 0
    
    //子音選択，母音選択の状態を管理するフラグ
    @State private var is_vowel = true
    
    //入力文字関連レジスタ
    @State private var enter_text = "" //入力文字を記憶する
    @State private var enter_pre_index = 0 //入力した文字の一個前の文字を指すインデックス
    @State private var enter_log = "" //すべての入力ログを記録する
    @State private var enter_alllog = "" //子音母音の入力ログを取る
    @State private var DeleteFlag = false //削除操作を行ったかどうか
    @State private var StartFlag = false //デジタルクラウン動かしたか
    @State private var DownFlag = false
    @State private var UpFlag = false
    
    @State private var AveSpeed:[CGFloat] = []
    @State private var SpeedSum:CGFloat = 0.0
    @State private var AveCnt:Int = 0
    @State private var AveRotationWhile:[CGFloat] = []
    @State private var allRotation:CGFloat = 0.0
    @State private var BaseRotation:CGFloat = 0.0
    @State private var ConsCnt:Int = 0
    @State private var VowelCnt:Int = 0
    @State private var OldIndex:Int = -1
    let DeleteSpeed = 3.0 //削除操作が実行されるスピード
    let CircleSpeed = 4.0 //3,4,5
    @State private var HenkanCnt = 0 //変換の際に何回実行したか記憶する
    @State private var DeleteCnt:Double = 0.0 //削除した回数
    @State private var prev_text = "" //変換される文字を記憶する
    
    //フレーズ入力関連レジスタ
    @State private var phrase_cnt = Int.random(in: 0 ..< phrase.count-1) //現在入力しているフレーズ
    @State private var session_maxcnt = 15
    @State private var phrase_dic = [Int:Int]() //フレーズの辞書
    @State private var isFinishSession = false //セッションが終わったかどうか
    
    //時間計測関連レジスタ
    @State var dateText = ""
    @State var CER = 0
    @State var CPM:String = ""
    @State var entry_time:String = ""
    
    @State var isFinish = false
    @State var TER:Double = 0.0 //Total Error rate
    @State var MSD:Double = 0.0 //MSD€
    @State var startTime:Date = Date()
    @State var CorrectFlag:Bool = false
    @State var isStartTime = false
    @State var firstflag:Bool = true
    
    @State var generator:SeedableRandomNumberGenerator
    
    
    //iPhoneに送信するモジュール宣言
    @ObservedObject private var connector = PhoneConnector()
    
    // init関数の追加
    init(CROWN_SPEED: Binding<Double>, DECISION_TIME: Binding<Double>) {
        self._CROWN_SPEED = CROWN_SPEED
        self._DECISION_TIME = DECISION_TIME
        self._generator = State(initialValue: SeedableRandomNumberGenerator(seed: UInt64(DispatchTime.now().uptimeNanoseconds)))
        
    }
    
    func knock(type: WKHapticType?){
        guard let hType = type else{return}
        WKInterfaceDevice.current().play(hType)
    }
    
    func count(){
        
    }
    
    func LevenshteinDistance(s1:String,s2:String)->Int{
        
        if s1.isEmpty {
            return s2.count
        }
        var d:[[Int]] = Array(repeating: Array(repeating: 0, count: s2.count + 1),count: s1.count + 1)
        
        for i1 in 0 ..< s1.count+1{
            d[i1][0] = i1
        }
        
        for i2 in 0 ..< s2.count+1{
            d[0][i2] = i2
        }
        
        for i1 in 1 ..< s1.count+1{
            for i2 in 1 ..< s2.count+1{
                let cost = s1[s1.index(s1.startIndex,offsetBy: i1-1)] == s2[s2.index(s2.startIndex,offsetBy: i2-1)] ? 0 : 1
                d[i1][i2] = min(d[i1-1][i2]+1,d[i1][i2-1]+1,d[i1-1][i2-1]+cost)
                
                
            }
        }
        
        return d[s1.count][s2.count]
    }
    
    func CalcParameter(){
        
            let timeInterval = Date().timeIntervalSince(startTime)
            let time = Int(timeInterval)
            
            
            let m = time / 60 % 60
            let s = time % 60
            
            // ミリ秒
            let ms = Int(timeInterval * 100) % 100
            
            entry_time = String(format: "%dm%d.%ds",  m, s, ms)
            CPM = String(Double(enter_log.count)/(Double(m)+(Double(s)+Double(ms)/100.0)/60.0))
            MSD = Double(LevenshteinDistance(s1: phrase[phrase_cnt], s2: enter_log)) / max(Double(enter_log.count),Double(enter_text.count))
            let C = max(Double(enter_log.count),Double(enter_text.count)) - Double(LevenshteinDistance(s1: phrase[phrase_cnt], s2: enter_log))
            TER = (Double(LevenshteinDistance(s1: phrase[phrase_cnt], s2: enter_log)) + Double(DeleteCnt)) / (C + (Double(LevenshteinDistance(s1: phrase[phrase_cnt], s2: enter_log)) + Double(DeleteCnt)))
        
    }
    
    func SendParameter(){
        if !CorrectFlag{
            print("incorrect")
            CalcParameter()
            print(entry_time)
        }
        CorrectFlag = false
        connector.send(phrase:phrase[phrase_cnt],phraseID:phrase_cnt,enter_log:enter_log,enter_alllog:enter_alllog,keystroke:enter_log.count,Time:entry_time,CPM:CPM,VowelCnt:VowelCnt,ConsCnt:ConsCnt,TER:TER,MSD:MSD,DeleteCnt:DeleteCnt,AveSpeed: AveSpeed,AveRotationWhile: AveRotationWhile)
    }
    
    func CheckVowelObj(isVive:Bool){
        for i in 0 ..< vowel_size {
            if degital_rotate >= 0{
                if (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0)) >= (start_angle + offset_vowel_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0))  <= (start_angle + offset_vowel_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) {
                    bar_color[i] = Color.red
                    if OldIndex != i && isVive{
                        knock(type: WKHapticType(rawValue: 6))
                        OldIndex = vowel_index
                    }
                    vowel_index = i
                }else{
                    bar_color[i] = Color.white
                }
            }else{
                if -1.0 * (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0)) >= (start_angle + offset_vowel_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && -1.0 * (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0))  <= (start_angle + offset_vowel_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) {
                    bar_color[vowel_size - i - 1] = Color.red
                    if OldIndex != vowel_size - i - 1 && isVive{
                        knock(type: WKHapticType(rawValue: 6))
                        OldIndex = vowel_index
                    }
                    vowel_index = vowel_size - i - 1
                }else{
                    bar_color[vowel_size - i - 1] = Color.white
                }
            }
            
        }
    }
    
    func CheckConsObj(isVive:Bool){
        for i in 0 ..< consonant[vowel_index].count {
            if degital_rotate >= 0 {
                if (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0)) >= (start_angle + offset_cons_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0))  <= (start_angle + offset_cons_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)){
                    bar_cons_color[i] = Color.red
                    if OldIndex != i && isVive{
                        knock(type: WKHapticType(rawValue: 6))
                        OldIndex = cons_index
                    }
                    cons_index = i
                }else{
                    bar_cons_color[i] = Color.white
                }
            }else{
                if -1.0 * (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0)) >= (start_angle + offset_cons_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && -1.0 * (degital_rotate).truncatingRemainder(dividingBy: CGFloat(360.0))  <= (start_angle + offset_cons_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) {
                    bar_cons_color[consonant[vowel_index].count - i - 1] = Color.red
                    if OldIndex != consonant[vowel_index].count - i - 1 && isVive{
                        knock(type: WKHapticType(rawValue: 6))
                        OldIndex = cons_index
                    }
                    cons_index = consonant[vowel_index].count - i - 1
                }else{
                    bar_cons_color[consonant[vowel_index].count - i - 1] = Color.white
                }
            }
           
        }
    }

    
    func Henkan(){
        
        
        enter_text.removeLast()
        enter_log.removeLast()
        
        enter_text.append((henkan[prev_text]?[HenkanCnt % henkan[prev_text]!.count])!)
        enter_log.append((henkan[prev_text]?[HenkanCnt % henkan[prev_text]!.count])!)
    }
    
    func SetCirclePos(){
        circlePositionX = length * cos((degital_rotate - 90) * Double.pi / 180.0) + CenterX
        circlePositionY = length * sin((degital_rotate - 90) * Double.pi / 180.0) + CenterY
    }
    var body: some View {
        if firstflag{
            
            Text("乱数セット").onAppear(){
                generator = SeedableRandomNumberGenerator(seed: UInt64(DispatchTime.now().uptimeNanoseconds))
                phrase_cnt = Int(generator.next() % 54)
                phrase_dic = [phrase_cnt: 1]
                
                firstflag = false
            }
        }
        if isFinishSession{
            ZStack{
                Text("Finish")
            }
        } else {
            ZStack{
                
                VStack{
                    Text(phrase[phrase_cnt])
                    Text(enter_text)
                    
                    
                }
                //外枠のオブジェクトの描画
                if is_vowel {
                    //子音
                    ForEach(0 ..< vowel_size, id: \.self){ i in
                        AShape(start_angle: (start_angle - 90) + offset_vowel_angle * CGFloat(i), offset_angle: offset_vowel_angle)
                            .stroke(style:StrokeStyle(lineWidth: 20))
                            .fill(bar_color[i])
                            .frame(width: MAX_WIDTH , height: MAX_HEIGHT)
                            .position(x: CenterX, y : CenterY)
                    }
                } else {
                    //母音
                    ForEach(0 ..< consonant[vowel_index].count, id: \.self){ i in
                        AShape(start_angle: (start_angle - 90) + offset_cons_angle * CGFloat(i), offset_angle: offset_cons_angle)
                            .stroke(style:StrokeStyle(lineWidth: 20))
                            .fill(bar_cons_color[i])
                            .frame(width: MAX_WIDTH , height: MAX_HEIGHT)
                        
                    }
                }
           
                // デジタルクラウンによって，回転する円カーソル
                Circle()
                    .fill(Color.green) // 円の色を設定
                    .frame(width: 15, height: 15) // 円のサイズを設定
                    .position(x: circlePositionX, y: circlePositionY) // 円の位置を指定
                    .focusable()
                    
                    .digitalCrownRotation(
                        detent: $degital_rotate,
                        from:-720, through: 720, by: CROWN_SPEED,
                        sensitivity:.high, isContinuous:true,isHapticFeedbackEnabled: true)
                { event in
                    
                    crownSpeed = event.velocity
                    
                    
//                    if crownSpeed > DeleteSpeed { //削除操作（デジタルクラウンを高速に上回転させたかどうか）
//                        
////                        StartFlag = false
////                        if !DeleteFlag && !enter_text.isEmpty {
////                            DeleteCnt += 1
////                            if is_vowel{
////                                enter_text.removeLast() //末尾の文字を削除
////                            } else {
////                                is_vowel = true
////                            }
////                            
////                            DeleteFlag = true //フラグON
////                            
////                        }
//                    } else 
                    if crownSpeed == 0{
                        DeleteFlag = false
                        
                        if StartFlag{
                            
                            StartFlag = false
                            if is_vowel {
                                if vowels[vowel_index] == "\",゜" {
                                    if !enter_text.isEmpty {
                                        if HenkanCnt == 0{
                                            prev_text = String(enter_text.last!)
                                        }
                                        if henkan.keys.contains(prev_text) {
                                            Henkan()
                                            HenkanCnt += 1
                                        }
                                    }
                                    
                                } else {
                                    offset_cons_angle = 360 / CGFloat(consonant[vowel_index].count)
                                    is_vowel.toggle()
                                    CheckConsObj(isVive: false)
                                    HenkanCnt = 0
                                    enter_alllog.append(vowels[vowel_index])
                                }
                                ConsCnt += 1
                            } else {
                                
                                enter_text.append(consonant[vowel_index][cons_index])
                                enter_log.append(consonant[vowel_index][cons_index])
                                enter_alllog.append(consonant[vowel_index][cons_index])
                                if enter_text == phrase[phrase_cnt]{
                                    CorrectFlag = true
                                    print("correct")
                                    CalcParameter()
                                    print(entry_time)
                                }
                                is_vowel.toggle()
                                CheckVowelObj(isVive: false)
                                VowelCnt += 1
                                AveSpeed.append(SpeedSum/CGFloat(AveCnt))
                                AveRotationWhile.append(allRotation)
                                AveCnt = 0
                                SpeedSum = 0.0
                                allRotation = 0.0
                            }
//                            print(SpeedSum/CGFloat(AveCnt))
                            
                            DownFlag = false
                            UpFlag = false
                            OldIndex = -1
                        }
                        
                        degital_rotate = 0.0

                        
                        
                        SetCirclePos()
                        
                        if is_vowel {
                            CheckVowelObj(isVive: false)
                        } else {
                            CheckConsObj(isVive: false)
                        }
                    } else { // デジタルクラウンを動かしている時
                        SpeedSum += CGFloat(crownSpeed)
                        AveCnt += 1
                        if !DownFlag && !UpFlag {
                            print("DU")
                            BaseRotation = abs(degital_rotate)
                        }
                        
                        if crownSpeed >= 0{
                            UpFlag = true
                            if DownFlag {
                                DownFlag = false
                                print("U to D")
                                BaseRotation = abs(degital_rotate)
                            }
                            allRotation += abs(abs(degital_rotate) - BaseRotation)
                            BaseRotation = abs(degital_rotate)
                        }else{
                            DownFlag = true
                            if UpFlag {
                                UpFlag = false
                                print("D to U")
                                BaseRotation = abs(degital_rotate)
                            }
                            allRotation += abs(abs(degital_rotate) - BaseRotation)
                            BaseRotation = abs(degital_rotate)
                        }
                        
                        StartFlag = DeleteFlag ? false : true//DeleteしているときはStarFlagはOFF
                        SetCirclePos()
                        if !isStartTime{
                            print("Start")
                            startTime = Date()
                            isStartTime = true
                        }
                        // 選択中のオブジェクトの色を赤くする
                        if is_vowel {
                            //　子音
                            CheckVowelObj(isVive: true)
                        } else {
                            //　母音
                            CheckConsObj(isVive: true)
                        }
                    }
                    
                }
                .onReceive(timer) { _ in
                    // Digital Crownの回転が一定時間止まったか確認
                    if Date().timeIntervalSince(lastUpdateTime) > updateThreshold && crownSpeed != 0 {
                        
                        // Digital Crownが回転していないとみなし、ここで必要な処理を実行
                        DeleteFlag = false
                       
                        if StartFlag{
                            
                            StartFlag = false
                            if is_vowel {
                                if vowels[vowel_index] == "\",゜" {
                                    if !enter_text.isEmpty {
                                        if HenkanCnt == 0{
                                            prev_text = String(enter_text.last!)
                                        }
                                        if henkan.keys.contains(prev_text) {
                                            Henkan()
                                            HenkanCnt += 1
                                        }
                                    }
                                    
                                } else {
                                    offset_cons_angle = 360 / CGFloat(consonant[vowel_index].count)
                                    is_vowel.toggle()
                                    CheckConsObj(isVive: false)
                                    HenkanCnt = 0
                                }
                                VowelCnt += 1
                            } else {
                                
                                enter_text.append(consonant[vowel_index][cons_index])
                                enter_log.append(consonant[vowel_index][cons_index])
                                is_vowel.toggle()
                                CheckVowelObj(isVive: false)
                                ConsCnt += 1
                                AveSpeed.append(SpeedSum/CGFloat(AveCnt))
                                AveCnt = 0
                                SpeedSum = 0.0
                                AveRotationWhile.append(allRotation)
                                allRotation = 0.0
                            }
                            
                            DownFlag = false
                            UpFlag = false
                            OldIndex = -1
                        }
                        
                        
                        degital_rotate = 0.0
                        
                        
                        
                        SetCirclePos()
                        
                        if is_vowel {
                            CheckVowelObj(isVive: false)
                        } else {
                            CheckConsObj(isVive: false)
                        }
                        
                    }
                }
                    .onChange(of: crownSpeed) {
                    lastUpdateTime = Date() // Digital Crownが回転しているたびに時間を更新
                }
                
                // ラベル
                if is_vowel {
                    // 子音
                    ForEach(0 ..< vowel_size, id: \.self){ i in
                        let rad_angle = ((start_angle - 90) + offset_vowel_angle * CGFloat(i) + offset_vowel_angle / 2) * Double.pi / 180.0
                        Text(vowels[i])
                            .position(x: (length + 37) * cos(rad_angle) + CenterX, y: (length + 37) * sin(rad_angle) + CenterY)
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 13).bold())
                    }
                } else {
                    // 母音
                    ForEach(0 ..< consonant[vowel_index].count, id: \.self){ i in
                        let rad_angle = ((start_angle - 90) + offset_cons_angle * CGFloat(i) + offset_cons_angle / 2) * Double.pi / 180.0
                        Text(consonant[vowel_index][i])
                            .position(x: (length + 37) * cos(rad_angle) + CenterX, y: (length + 37) * sin(rad_angle) + CenterY)
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 20).bold())
                    }
                }
            }
            .onTapGesture(){ touch_pos in
                
                if phrase_dic.count <= session_maxcnt {
                    isStartTime = false
                    
                    SendParameter()
            
                    phrase_cnt = Int(generator.next() % 54)
                    
                    while phrase_dic.keys.contains(phrase_cnt){
                        phrase_cnt = Int(generator.next() % 54)
                        
                    }
                    phrase_dic[phrase_cnt] = 1
                    enter_text.removeAll()
                    enter_log.removeAll()
                    enter_alllog.removeAll()
                    AveSpeed.removeAll()
                    AveRotationWhile.removeAll()
                    DeleteCnt = 0
                }else{
                    isFinishSession = true
                }
                
            }
            .gesture(DragGesture()
                .onEnded{ gesture in
                    if gesture.translation.width > 0 {
                        
                    }else{
                        
                        if !enter_text.isEmpty && is_vowel{
                            DeleteCnt += 1
                            
                            enter_text.removeLast() //末尾の文字を削除
                           
                            
                            SetCirclePos()
                            
                            CheckVowelObj(isVive: false)
                           
                        }
                    }
                }
            )
        }
    }
}



#Preview {
    StartListView()
}


struct AShape: Shape {
    var st_ang:CGFloat
    var oft_ang:CGFloat
    
    init(start_angle:CGFloat, offset_angle: CGFloat){
        self.st_ang = start_angle
        self.oft_ang = offset_angle
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.maxX / 2,
            startAngle: Angle(degrees: self.st_ang +  padding_angle),
            endAngle: Angle(degrees: self.st_ang + self.oft_ang - padding_angle),
            clockwise: false
        )
        
        return path
            
    }
}

//struct PreDialCrownView: View {
//    
//    @State private var degital_rotate: CGFloat = 0.0
//    @State private var crownSpeed:CGFloat = 0.0
//    @State private var lastUpdateTime = Date()
//    private let updateThreshold = 0.05 // Digital Crownの回転が止まったとみなす秒数
//    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect() // 0.1秒ごとにタイマーイベントを発行
//    @State private var circlePositionX: CGFloat = length * cos(270 * Double.pi / 180.0) + CenterX
//    @State private var circlePositionY: CGFloat = length * sin(270 * Double.pi / 180.0) + CenterY
//    
//    
//    @State private var bar_color = [Color.red,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white]
//    
//    @State private var bar_cons_color = [Color.red,Color.white,Color.white,Color.white,Color.white]
//    
//    // 子音および母音をさすインデックス
//    @State private var vowel_index = 0
//    @State private var cons_index = 0
//    
//    //子音選択，母音選択の状態を管理するフラグ
//    @State private var is_vowel = true
//    
//    //入力文字関連レジスタ
//    @State private var enter_text = "" //入力文字を記憶する
//    @State private var enter_pre_index = 0 //入力した文字の一個前の文字を指すインデックス
//    @State private var enter_log = "" //すべての入力ログを記録する
//    @State private var DeleteFlag = false //削除操作を行ったかどうか
//    @State private var StartFlag = false //デジタルクラウン動かしたか
//    let DeleteSpeed = 3.0 //削除操作が実行されるスピード
//    let CircleSpeed = 4.0
//    @State private var HenkanCnt = 0 //変換の際に何回実行したか記憶する
//    @State private var DeleteCnt:Double = 0.0 //削除した回数
//    @State private var prev_text = "" //変換される文字を記憶する
//    
//    //フレーズ入力関連レジスタ
//    @State private var phrase_cnt = Int.random(in: 0 ..< phrase.count-1) //現在入力しているフレーズ
//    @State private var session_maxcnt = 10
//    @State private var phrase_dic = [Int:Int]() //フレーズの辞書
//    @State private var isFinishSession = false //セッションが終わったかどうか
//    
//    //時間計測関連レジスタ
//    @State var dateText = ""
//    @State var CER = 0
//    @State var CPM:String = ""
//    @State var entry_time:String = ""
//    @State var isFinish = false
//    @State var TER:Double = 0.0
//    @State var startTime:Date = Date()
//    @State var isStartTime = false
//    
//    
//    
//    
//    //iPhoneに送信するモジュール宣言
//    @ObservedObject private var connector = PhoneConnector()
//    
//    init(){
//        _phrase_dic = State(initialValue: [phrase_cnt:1])
//    }
//    
//    func LevenshteinDistance(s1:String,s2:String)->Int{
//        
//        if s1.isEmpty {
//            return s2.count
//        }
//        var d:[[Int]] = Array(repeating: Array(repeating: 0, count: s2.count + 1),count: s1.count + 1)
//        
//        for i1 in 0 ..< s1.count+1{
//            d[i1][0] = i1
//        }
//        
//        for i2 in 0 ..< s2.count+1{
//            d[0][i2] = i2
//        }
//        
//        for i1 in 1 ..< s1.count+1{
//            for i2 in 1 ..< s2.count+1{
//                let cost = s1[s1.index(s1.startIndex,offsetBy: i1-1)] == s2[s2.index(s2.startIndex,offsetBy: i2-1)] ? 0 : 1
//                d[i1][i2] = min(d[i1-1][i2]+1,d[i1][i2-1]+1,d[i1-1][i2-1]+cost)
//                
//                
//            }
//        }
//        
//        return d[s1.count][s2.count]
//    }
//    
//    func CalcParameter(){
//        let timeInterval = Date().timeIntervalSince(startTime)
//        let time = Int(timeInterval)
//        
//        
//        let m = time / 60 % 60
//        let s = time % 60
//        
//        // ミリ秒
//        let ms = Int(timeInterval * 100) % 100
//        
//        entry_time = String(format: "%dm%d.%ds",  m, s, ms)
//        CPM = String(Double(phrase[phrase_cnt].count)/(Double(m)+(Double(s)+Double(ms)/100.0)/60.0))
//        TER = Double(LevenshteinDistance(s1: phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
//        
//        connector.send(phrase:phrase[phrase_cnt],phraseID:phrase_cnt,enter_log:enter_log,keystroke:enter_log.count,Time:entry_time,CPM:CPM,TER:TER,DeleteCnt:DeleteCnt,AveSpeed: AveSpee)
//    }
//    func drawVowel(){
//        
//    }
//    func CheckVowelObj(){
//        for i in 0 ..< vowel_size {
//            
//            if degital_rotate >= (start_angle + offset_vowel_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && degital_rotate  <= (start_angle + offset_vowel_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) {
//                bar_color[i] = Color.red
//                vowel_index = i
//            }else{
//                bar_color[i] = Color.white
//            }
//            
//        }
//    }
//    
//    func CheckConsObj(){
//        for i in 0 ..< consonant[vowel_index].count {
//            
//            if degital_rotate >= (start_angle + offset_cons_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && degital_rotate  <= (start_angle + offset_cons_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) {
//                bar_cons_color[i] = Color.red
//                cons_index = i
//            }else{
//                bar_cons_color[i] = Color.white
//            }
//           
//        }
//    }
//    
//    func Henkan(){
//        
//        
//        enter_text.removeLast()
//        enter_log.removeLast()
//        
//        enter_text.append((henkan[prev_text]?[HenkanCnt % henkan[prev_text]!.count])!)
//        enter_log.append((henkan[prev_text]?[HenkanCnt % henkan[prev_text]!.count])!)
//    }
//    
//    func SetCirclePos(){
//        circlePositionX = length * cos((degital_rotate - 90) * Double.pi / 180.0) + CenterX
//        circlePositionY = length * sin((degital_rotate - 90) * Double.pi / 180.0) + CenterY
//    }
//    var body: some View {
//       
//        if isFinishSession{
//            ZStack{
//                Text("Finish")
//            }
//        } else {
//            ZStack{
//                
//                VStack{
//                    Text(phrase[phrase_cnt])
//                    Text(enter_text)
//                }
//                //外枠のオブジェクトの描画
//                if is_vowel {
//                    //子音
//                    ForEach(0 ..< vowel_size, id: \.self){ i in
//                        AShape(start_angle: (start_angle - 90) + offset_vowel_angle * CGFloat(i), offset_angle: offset_vowel_angle)
//                            .stroke(style:StrokeStyle(lineWidth: 20))
//                            .fill(bar_color[i])
//                            .frame(width: MAX_WIDTH , height: MAX_HEIGHT)
//                            .position(x: CenterX, y : CenterY)
//                    }
//                } else {
//                    //母音
//                    ForEach(0 ..< consonant[vowel_index].count, id: \.self){ i in
//                        AShape(start_angle: (start_angle - 90) + offset_cons_angle * CGFloat(i), offset_angle: offset_cons_angle)
//                            .stroke(style:StrokeStyle(lineWidth: 20))
//                            .fill(bar_cons_color[i])
//                            .frame(width: MAX_WIDTH , height: MAX_HEIGHT)
//                        
//                    }
//                }
//           
//                // デジタルクラウンによって，回転する円カーソル
//                Circle()
//                    .fill(Color.green) // 円の色を設定
//                    .frame(width: 15, height: 15) // 円のサイズを設定
//                    .position(x: circlePositionX, y: circlePositionY) // 円の位置を指定
//                    .focusable()
//                    
//                    .digitalCrownRotation(
//                        detent: $degital_rotate,
//                        from:0, through: 360, by: CircleSpeed,
//                        sensitivity:.high, isContinuous:true)
//                { event in
//                    
//                    crownSpeed = event.velocity
//                    
//                    
//                    if crownSpeed > DeleteSpeed { //削除操作（デジタルクラウンを高速に上回転させたかどうか）
//                        StartFlag = false
//                        if !DeleteFlag && !enter_text.isEmpty {
//                            DeleteCnt += 1
//                            if is_vowel{
//                                enter_text.removeLast() //末尾の文字を削除
//                            } else {
//                                is_vowel = true
//                            }
//                            
//                            DeleteFlag = true //フラグON
//                            
//                        }
//                    } else if crownSpeed == 0{
//                        DeleteFlag = false
//                        print(StartFlag)
//                        if StartFlag{
//                            
//                            StartFlag = false
//                            if is_vowel {
//                                if vowels[vowel_index] == "\",゜" {
//                                    if !enter_text.isEmpty {
//                                        if HenkanCnt == 0{
//                                            prev_text = String(enter_text.last!)
//                                        }
//                                        if henkan.keys.contains(prev_text) {
//                                            Henkan()
//                                            HenkanCnt += 1
//                                        }
//                                    }
//                                    
//                                } else {
//                                    offset_cons_angle = 360 / CGFloat(consonant[vowel_index].count)
//                                    is_vowel.toggle()
//                                    CheckConsObj()
//                                    HenkanCnt = 0
//                                }
//                            } else {
//                                
//                                enter_text.append(consonant[vowel_index][cons_index])
//                                enter_log.append(consonant[vowel_index][cons_index])
//                                is_vowel.toggle()
//                                CheckVowelObj()
//                            }
//                            
//                        }
//                        
//                        degital_rotate = 0.0
//                        SetCirclePos()
//                        
//                        if is_vowel {
//                            CheckVowelObj()
//                        } else {
//                            CheckConsObj()
//                        }
//                    } else { // デジタルクラウンを動かしている時
//                        
//                        StartFlag = DeleteFlag ? false : true//DeleteしているときはStarFlagはOFF
//                        SetCirclePos()
//                        if !isStartTime{
//
//                            startTime = Date()
//                            isStartTime = true
//                        }
//                        // 選択中のオブジェクトの色を赤くする
//                        if is_vowel {
//                            //　子音
//                            CheckVowelObj()
//                        } else {
//                            //　母音
//                            CheckConsObj()
//                        }
//                    }
//                    
//                }
//                
//                // ラベル
//                if is_vowel {
//                    // 子音
//                    ForEach(0 ..< vowel_size, id: \.self){ i in
//                        let rad_angle = ((start_angle - 90) + offset_vowel_angle * CGFloat(i) + offset_vowel_angle / 2) * Double.pi / 180.0
//                        Text(vowels[i])
//                            .position(x: (length + 37) * cos(rad_angle) + CenterX, y: (length + 37) * sin(rad_angle) + CenterY)
//                            .foregroundColor(Color.black)
//                            .font(Font.system(size: 13).bold())
//                    }
//                } else {
//                    // 母音
//                    ForEach(0 ..< consonant[vowel_index].count, id: \.self){ i in
//                        let rad_angle = ((start_angle - 90) + offset_cons_angle * CGFloat(i) + offset_cons_angle / 2) * Double.pi / 180.0
//                        Text(consonant[vowel_index][i])
//                            .position(x: (length + 37) * cos(rad_angle) + CenterX, y: (length + 37) * sin(rad_angle) + CenterY)
//                            .foregroundColor(Color.black)
//                            .font(Font.system(size: 20).bold())
//                    }
//                }
//            }
//            .onTapGesture(){ touch_pos in
//                if touch_pos.x >= 100{
//                    if phrase_dic.count <= session_maxcnt {
//                        isStartTime = false
//                        
//                        CalcParameter()
//                
//                        phrase_cnt = Int.random(in: 0 ..< phrase.count-1)
//                        
//                        while phrase_dic.keys.contains(phrase_cnt){
//                            phrase_cnt = Int.random(in: 0 ..< phrase.count-1)
//                            
//                        }
//                        phrase_dic[phrase_cnt] = 1
//                        enter_text.removeAll()
//                        enter_log.removeAll()
//                        
//                    }else{
//                        isFinishSession = true
//                    }
//                    
//                }
//            }
//        }
//
//       
//    }
//    
//}



class PhoneConnector: NSObject, ObservableObject, WCSessionDelegate {
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    
    
    func send(phrase:String,phraseID:Int,enter_log:String,enter_alllog:String,keystroke:Int,Time:String,CPM:String,VowelCnt:Int,ConsCnt:Int,TER:Double,MSD:Double,DeleteCnt:Double,AveSpeed:[CGFloat],AveRotationWhile:[CGFloat]) -> Text{
        if WCSession.default.isReachable {
            
            
            WCSession.default.sendMessage(["phrase":phrase,"phraseID":phraseID,"enter_log":enter_log,"enter_alllog":enter_alllog,"Keystroke":keystroke,"Time":Time,"CPM": CPM,"VowelCnt": VowelCnt,"ConsCnt":ConsCnt,"TER": TER,"MSD":MSD,"DeleteCnt":DeleteCnt,"AveSpeed":AveSpeed,"AveRotationWhile":AveRotationWhile], replyHandler: nil) {
                error in
                print(error)
            }
        }
        return Text("")
    }
}
