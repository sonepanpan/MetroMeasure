//
//  addNewPaperView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/14.
//

import SwiftUI

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
    @State var showScanView = false


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
                    DatePicker("開工日期: ", selection: $startDate/*, displayedComponents: .date*/).frame(alignment: .center)
                    HStack{
                        Text("集電靴1: ")
                        Text(carriageNum + "  " + deviceNum)
                        Button(action: {showScanView = true}, label: {
                            Image(systemName: "qrcode.viewfinder")
                        }).frame(alignment: .center).sheet(isPresented: $showScanView, content: {
                            MeasureView(showScanView: $showScanView, carriageNum: $carriageNum, deviceNum: $deviceNum)
                        }
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
        let newPaper =  Paper(groupNum: groupNum, paperNum: paperNum, startDate: startDate, operatorName: operatorName, Carriages: nil, isSafed: false)
        parameters.papers.append(newPaper)
        print("Success Add New Paper: \(newPaper)")
        isAdded = true
    }
}
