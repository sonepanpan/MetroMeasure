//
//  ControlView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct MeasureView: View {
    
    @EnvironmentObject var parameters: AppParameters
    
    
    @Binding var showScanView: Bool
    @Binding var carriageNum: String
    @Binding var deviceNum: String
    @Binding var safeNum: Int

//    @State var isScanned = false
//    @State var isThhcknessFinished = false
//    @State var isHeightPassed: Bool = false
    @State var isDeviceFinished: Bool = false
    @State var step = stage.qrcode
    @State var check = item.thickness
    

    enum stage {
        case qrcode
        case measure
    }
    
    enum item{
        case thickness
        case height
    }
    

    
    var body: some View {
        Group{
            switch step {
            case .qrcode:
                ScanView(step: $step, carriageNum: $carriageNum, deviceNum: $deviceNum)
//                continue
            case .measure:
                ZStack(alignment: .center){
                    arViewContainer.ignoresSafeArea()
                    switch check {
                    case .thickness:
                        thicknessView(check: $check)
                    case .height:
                        if isDeviceFinished{
                            MeasureRailHeight(showScanView: $showScanView, safeNum: $safeNum, isHeightPassed: $isDeviceFinished)
                        }
                        else{
                            MeasureDeviceHeight(isDeviceFinished: $isDeviceFinished)
                        }
                    }
                }.navigationBarHidden(true)

            }
        }
//        .onAppear(perform: {arViewContainer = ARViewContainer()})
    }
}

    

