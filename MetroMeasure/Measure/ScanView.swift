//
//  ScanView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/8.
//

import SwiftUI
import CodeScanner

struct ScanView: View{

    @EnvironmentObject var parameters: AppParameters

    @State var Result: String = "Scan the QRCode"
    @State var isScanWorked = false
//    @Binding var isScanned: Bool
    @Binding var step: MeasureView.stage
    @Binding var carriageNum: String
    @Binding var deviceNum: String

    
    var body: some View{
        ZStack{

            CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)
            VStack{
                Text(Result).font(.title3).frame(alignment: .center)//.foregroundColor(.black).background(Color.blue).position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*3)
                Button("COMFIRM"){step = MeasureView.stage.measure}.frame(width: 130, height: 60, alignment: .center)
                    .font(.title2)
                    .foregroundColor(.white)
                    .background(isScanWorked ? Color.blue : Color.gray)
                    .opacity(0.85)
                    .cornerRadius(10)
                    .padding(20)
                    .disabled(!isScanWorked)
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/10*2.5, alignment: .center).background(Color.white)
            .position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*8)
        }
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        switch result {
        case .success(let data):
            let details = data.components(separatedBy: ",")
            print(details.count)
            guard details.count == 2 else{return}
            isScanWorked = true
            Result = details[0] + " " + details[1]
            print(details)
            carriageNum = details[0]
            deviceNum = details[1]
            parameters.carriage = Carriage(carriageNum: carriageNum, deviceNum: deviceNum)
            print("Success with \(data)")
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
    //    func handleScan(result: Result<String, CodeScannerView.ScanError>){
    //        self.isShowingScanner = false
    //        //more code
    //        switch result{
    //        case .success(let code):
    //            let details = code.components(separatedBy: "\n")
    //            guard details.count == 2 else {return}
    //            print(details)
    ////            let data = Prospect
    ////            data.name = details[0]
    ////            data.num = detail[1]
    ////            self.prospect.data.append(data)
    //        case .failure(_):
    //            print("DEBUG: Scanning failed.")
    //
    //        }
    //
    //    }
}

