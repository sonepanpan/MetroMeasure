//
//  SearchView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/10/10.
//

import SwiftUI
import CoreML
import CoreAudio

struct SearchHistoryView: View {
    
    @State var groupNum: String = "102"
    @State var carriageNum: String = "happy"
    @State var deviceNum: String = "L1"
    @State var histories: Histories?
    @State var hint: String = "Press Button to Search"
    
    let groupNumOptions: [String] = ["Q", "102", "103", "104", "105"]
    let carriageNumOptions: [String] = ["happy","1102", "1202", "1302", "1402"]
    let deviceNumOptions: [String] = ["L1","L2", "R1", "R2"]
    
    var body: some View {
        List{
            VStack(alignment: HorizontalAlignment.leading, spacing: 20){
                HStack{
                    Image(systemName: "tram")
                    Text(" 車組號碼 ")
                    Picker(selection: $groupNum,
                           content: {
                        ForEach(groupNumOptions, id: \.self) {option in
                            Text(option).tag(option)
                        }
                    }, label: {
                        Text("-")
                    }).pickerStyle(MenuPickerStyle()).padding(.horizontal)
                }
                
                HStack{
                    Image(systemName: "rectangle")
                    Text("車廂號碼")
                    Picker(selection: $carriageNum,
                           content: {
                        ForEach(carriageNumOptions, id: \.self) {option in
                            Text(option).tag(option)
                        }
                        
                    }, label: {
                        Text("-")
                    }).pickerStyle(MenuPickerStyle()).padding(.horizontal)
                }
                
                HStack{
                    Image(systemName: "rectangle.roundedtop")
                    Text("    集電靴 ")
                    Picker(selection: $deviceNum,
                           content: {
                        ForEach(deviceNumOptions, id: \.self) {option in
                            Text(option).tag(option)
                        }
                    }, label: {
                        Text("-").font(.headline)
                    }).pickerStyle(MenuPickerStyle()).padding(.horizontal)
                }
            }
        }
        
        
        if self.histories != nil{
            deviceDetailView(Histories: self.histories!).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2, alignment: .leading)
        }
        
        
        
        Text(hint).opacity(0.9).foregroundColor(Color.black).font(.headline)
        
        Button(action: {
            self.histories = nil
            MetroDataController().GetMetroData(groupNum: groupNum, carriageNum: carriageNum, deviceNum: deviceNum){ Histories in
                DispatchQueue.main.async {
                    if Histories.rows.isEmpty  {
                        print("row is empty")
                        hint = "Empty"
                        self.histories = nil
                    }
                    else{
                        self.histories = Histories
                        print(Histories)
                        hint = "Check Now"
                    }
                }
            }
        }, label: {
            Text("Search History").bold().frame(width: 250, height: 50, alignment: .center)
                .background(Color.green).cornerRadius(8).foregroundColor(.white)
        }).padding()
            .frame(width: 250, height: 50)
            .navigationTitle("Search History")
    }
}

struct deviceDetailView: View{
    var Histories: Histories
    
    var body: some View{
        ScrollView(.horizontal,showsIndicators: true)
        {
            HStack{
                ForEach(0..<Histories.rows.count) { i in
                    PaperView(row: Histories.rows[i])
                }
            }
        }.position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*2.4)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2, alignment: .leading)
    }
}

struct PaperView: View{
    var row: row
    var body: some View{
        List{
            Label(
                title: {Text("工單號碼: \(row.paperNum)")},
                icon: { Image(systemName: "newspaper")}
            )
            Label(
                title: {Text("開工日期: \(row.startDate)")},
                icon: { Image(systemName: "play.fill")}
            )
            Label(
                title: {Text("執行人員: \(row.operatorName)")},
                icon: { Image(systemName: "person.fill")}
            )
            Label(
                title: {Text("集電靴:")},
                icon: { Image(systemName: "rectangle.roundedtop")}
            )
            Label(
                title: {Text("         厚度: ") + Text(row.thicknessIsQualified ? "OK" : "NG"+", Change  \(row.changeNum)")},
                icon: {}
            )
            if row.heightAfter < 0 {
                Label(
                    title: {Text("         高度: OK")},
                    icon: {}
                )
                Label(
                    title: {Text("             調整前: \(String(format: "%.2f cm", row.heightBefore))")},
                    icon: {}
                )
            }
            else{
                Label(
                    title: {Text("         高度: NG")},
                    icon: {}
                )
                Label(
                    title: {Text("              調整前: \(String(format: "%.2f cm", row.heightBefore))")},
                    icon: {}
                )
                Label(
                    title: {Text("              調整後: \(String(format: "%.2f cm", row.heightAfter))")},
                    icon: {}
                )
            }
        }.cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).frame(width: 300, height: UIScreen.main.bounds.height/2, alignment: .leading).foregroundColor(Color.black)
        //            .position(x: UIScreen.main.bounds.width/3 , y: UIScreen.main.bounds.height/2)
    }
}

