//
//  addNewPaperView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/14.
//

import SwiftUI

struct addNewPaperView: View{
    
    @EnvironmentObject var parameters: AppParameters
    @State var groupNum = "Q"
    @State var paperNum = "Q"
    @State var operatorName = "Q"
    @State var startDate = Date.init()
    @State var carriageNum = ""
    @State var deviceNum = ""
    @State var message = "Please Add Paper First"
    @State var isAdded = false
    @State var showScanView = false
    @State var showRailHeightMeasured = false
    @State var isRailHeightMeasured = false
    @State var safeNum: Int = 0
    
    
    var body: some View{
        VStack{
            List{
                Section{
                    HStack{
                        Text("車組編號: ")
                        TextField("102" , text: $groupNum )
                    }.disabled(isAdded).opacity(isAdded ? 0.3 : 1)
                    HStack{
                        Text("工單號碼: ")
                        TextField("W0502698" , text: $paperNum )
                    }.disabled(isAdded).opacity(isAdded ? 0.3 : 1)
                    HStack{
                        Text("執行人員: ")
                        TextField("Paul" , text: $operatorName)
                    }.disabled(isAdded).opacity(isAdded ? 0.3 : 1)
                    DatePicker("開工日期: ", selection: $startDate, displayedComponents: .date)
                        .frame(alignment: .center).disabled(isAdded)
                        .opacity(isAdded ? 0.3 : 1)
                    
                    
//                    HStack{
//                        Text("鐵軌高度: ")
//                        Text(String(format: "%.2f cm", parameters.measuredRailHeight*100))
//                        Button(action: {showRailHeightMeasured = true}, label: {
//                            Image(systemName: "ruler")
//                        }).frame(alignment: .center).sheet(isPresented: $showRailHeightMeasured, content: {/*MeasureRailHeight(showRailHeightMeasured: $showRailHeightMeasured)*/}
//                        ).disabled(!isAdded)
//                    }.opacity(isAdded ? 1 : 0.3)
                    
                    
                    HStack{
                        Text("集電靴: ")
                        Text(carriageNum + "  " + deviceNum)
                        Button(action: {showScanView = true}, label: {
                            Image(systemName: "qrcode.viewfinder")
                        }).frame(alignment: .center).sheet(isPresented: $showScanView, content: {
                            MeasureView(showScanView: $showScanView, carriageNum: $carriageNum, deviceNum: $deviceNum, safeNum: $safeNum)
                        }).disabled(!isAdded)
                    }.opacity(isAdded ? 1 : 0.3)
                }.padding().navigationTitle("Please fill the blank")
                
                Text("Add \(safeNum) Device")

            }
            
            
            //
            Text(message).font(.headline)
            
            Button(action: {
                //tryToAddList()
                parameters.paper = Paper(groupNum: groupNum, paperNum: paperNum, startDate: startDate, operatorName: operatorName)
                isAdded = true
                message = "Add Device Now"
            }, label: {
                Text("Add New Paper").bold().frame(width: 250, height: 50, alignment: .center)
                    .background(isAdded || (!(!groupNum.trimmingCharacters(in: .whitespaces).isEmpty && !paperNum.trimmingCharacters(in: .whitespaces).isEmpty) || (operatorName.trimmingCharacters(in: .whitespaces).isEmpty)) ? Color.gray : .green).cornerRadius(8).foregroundColor(.white)
            }).padding().disabled(isAdded || (!(!groupNum.trimmingCharacters(in: .whitespaces).isEmpty && !paperNum.trimmingCharacters(in: .whitespaces).isEmpty) || (operatorName.trimmingCharacters(in: .whitespaces).isEmpty)))
        }
    }
}

//    func tryToAddList() {
//        guard !groupNum.trimmingCharacters(in: .whitespaces).isEmpty else{return}
//        guard !paperNum.trimmingCharacters(in: .whitespaces).isEmpty else{return}
//        guard !operatorName.trimmingCharacters(in: .whitespaces).isEmpty else{return}
//        let newPaper =  Paper(groupNum: groupNum, paperNum: paperNum, startDate: startDate, operatorName: operatorName, Carriages: nil, isSafed: false)
//        parameters.papers.append(newPaper)
//        print("Success Add New Paper: \(newPaper)")
//        isAdded = true
//    }
//}
