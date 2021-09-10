//
//  ListView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/8.
//

import SwiftUI
import UIKit


struct ListView: View {
    
    @EnvironmentObject var parameters: AppParameters
    @State var refresh = false
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 5)
        {
            Section{
                NavigationLink(destination: addNewPaperView(),
                               label: {Text("Add to List").frame(width: 250, height: 50, alignment: .center).background(Color.green).cornerRadius(8).foregroundColor(.white)
                               }
                )}.padding()
            if refresh{
                List{
                    ForEach(0 ..< parameters.papers.count){ index in
                        PaperRow(title: parameters.papers[index].paperNum)
                    }
                }
            }
            else{
                List{
                    ForEach(0 ..< parameters.papers.count){ index in
                        PaperRow(title: parameters.papers[index].paperNum)
                    }}
            }
        }.navigationTitle("List")
        .navigationBarItems(trailing: Button(action: {refresh.toggle()}
                                            ,label: {
                                                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(Color.blue)
                                            }))
    }

}


struct PaperRow: View {
    let title: String
    var body: some View{
        Label(
            title: {Text(title)},
            icon: { Image(systemName: "chart.bar")}
        ).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).frame(width: 250, height: 50, alignment: .leading).foregroundColor(Color.black)
    }
}

struct addNewPaperView: View{
    
    @EnvironmentObject var parameters: AppParameters
    @State var groupNum = ""
    @State var paperNum = ""
    @State var operatorName = ""
    @State var startDate = Date.init()
    @State var carriageNum = ""
    @State var deviceNum = ""
    @State var message = ""
    @State var isAdded = false
    @State var showScaned = false
    @State var isScanned = false
    
    var body: some View{
        VStack{
            List{
                Section{
                    HStack{
                        Text("車組編號: ")
                        TextField("102" , text: $groupNum )
                    }
                    HStack{
                        Text("工單號碼: ")
                        TextField("W0502698" , text: $paperNum )
                    }
                    HStack{
                        Text("執行人員: ")
                        TextField("Paul" , text: $operatorName)
                    }
                    DatePicker("開工日期: ", selection: $startDate/*, displayedComponents: .date*/)
                    HStack{
                        Text("集電靴1: ")
                        Text(carriageNum + "  " + deviceNum)
                        Button(action: {showScaned = true}, label: {
                            Image(systemName: "qrcode.viewfinder")
                        }).sheet(isPresented: $showScaned, content: {
                            ScanView(showScaned: $showScaned, carriageNum: $carriageNum, deviceNum: $deviceNum)}
                        )
                    }
                }.padding().navigationTitle("Please fill the blank")
            }
            Button(action: {
                    tryToAddList()
                    message = "Added to List"
            }, label: {
                Text("Add New Paper").bold().frame(width: 250, height: 50, alignment: .center)
                    .background(isAdded || (!(!groupNum.trimmingCharacters(in: .whitespaces).isEmpty && !paperNum.trimmingCharacters(in: .whitespaces).isEmpty) || (operatorName.trimmingCharacters(in: .whitespaces).isEmpty)) ? Color.gray : .green).cornerRadius(8).foregroundColor(.white)
            }).padding().disabled(isAdded || (!(!groupNum.trimmingCharacters(in: .whitespaces).isEmpty && !paperNum.trimmingCharacters(in: .whitespaces).isEmpty) || (operatorName.trimmingCharacters(in: .whitespaces).isEmpty)))
            Text(message).font(.headline)
        }
    }
    
    
    func tryToAddList() {
        guard !groupNum.trimmingCharacters(in: .whitespaces).isEmpty else{return}
        guard !paperNum.trimmingCharacters(in: .whitespaces).isEmpty else{return}
        guard !operatorName.trimmingCharacters(in: .whitespaces).isEmpty else{return}
        let newPaper =  Paper(groupNum: groupNum, paperNum: paperNum, startDate: startDate, operatorName: operatorName, Devices: nil, isSafed: false)
        parameters.papers.append(newPaper)
        print("Success Add New Paper: \(newPaper)")
        isAdded = true
    }
}
