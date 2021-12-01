//
//  MeasureRailHeight.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/30.
//

import SwiftUI
import AVFoundation

struct MeasureRailHeight: View {
    
    @EnvironmentObject var parameters: AppParameters
    @State var isRailFinished: Bool = false
    @State var isPassed: Bool = false
    @State private var flashlight = false
    
    @Binding var showScanView: Bool
    @Binding var safeNum: Int
    @Binding var isHeightPassed: Bool
    
    
    var body: some View {
        ZStack(alignment: .center){
            VStack{
                Toggle("Need Some Light?", isOn: $flashlight).foregroundColor(.white).onChange(of: flashlight, perform: { value in
                    if flashlight{
                        toggleTorch(on: true)
                    }
                    else{
                        toggleTorch(on: false)
                    }
                }).frame(width: 250, height: 30, alignment: .center).padding()
                HStack{
                    Image(systemName: "minus")
                    Image(systemName: "minus")
                    Image(systemName: "minus")
                }.foregroundColor(.yellow)
                    .position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*3.8)
            }
            if isRailFinished{
                RailResultView(isRailFinished: $isRailFinished, showScanView: $showScanView, isHeightPassed: $isHeightPassed, isPassed: $isPassed, safeNum: $safeNum)
            }
            else{
                RailControlView(isRailFinished: $isRailFinished, isPassed: $isPassed)
            }
        }.navigationBarHidden(true)
    }
}



struct RailResultView: View {
    
    @EnvironmentObject var parameters: AppParameters
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var isRailFinished: Bool
    @Binding var showScanView: Bool
    @Binding var isHeightPassed: Bool
    @Binding var isPassed: Bool
    @Binding var safeNum: Int
    
    //    var carriage: Carriage
    
    var body: some View {
        HStack(alignment: .center){
            //Reset Button
            Button(action: {
                arViewContainer.arView.resetAllPoint()
                arViewContainer.arView.resetAllCheckPointRail()
                isHeightPassed = false
                parameters.measuredHeightBefore = (parameters.measuredDeviceHeight - parameters.measuredRailHeight)*100
            })
            {Image(systemName: "arrow.counterclockwise").foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(isPassed ? Color.gray : Color.blue)
                    .opacity(0.85)
                    .cornerRadius(30)
                    .padding(20)
            }.disabled(isPassed)
            
            Text(String(format: "%.2f\n cm", (parameters.measuredDeviceHeight-parameters.measuredRailHeight)*100))
                .frame(width: 100, height: 100, alignment: .center)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(20)
            
            //Return to AddNewPaperView
            Button(action: {
                print("safeNum: \(safeNum)")
                showScanView = false
                arViewContainer.arView.resetAllPoint()
                arViewContainer.arView.resetAllCheckPointRail()
                parameters.measuredHeightAfter = (parameters.measuredDeviceHeight - parameters.measuredRailHeight)*100
                safeDeviceRecord()
                resetDeviceParameter()
                safeNum+=1
                print("safeNum: \(safeNum)")
            })
            {Image(systemName: "paperplane").foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(!(isPassed) ? Color.gray : Color.blue)
                    .opacity(0.85)
                    .cornerRadius(30)
                    .padding(20)
            }.disabled(!(isPassed))
        }.position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*8)
    }
    
    func safeDeviceRecord(){
        if parameters.measuredHeightBefore == -1 {
            print("-1")
            MetroDataController().PutMetroData(paper: parameters.paper, carrige: parameters.carriage, device: Device(thicknessIsQualified: parameters.measuredThickness, changeNum: parameters.measuredChangeNum, heightBefore: parameters.measuredHeightAfter , heightAfter: -1))
            
        }
        else{
            MetroDataController().PutMetroData(paper: parameters.paper, carrige: parameters.carriage, device: Device(thicknessIsQualified: parameters.measuredThickness, changeNum: parameters.measuredChangeNum, heightBefore: parameters.measuredHeightBefore , heightAfter: parameters.measuredHeightAfter))
        }
        
    }
    func resetDeviceParameter(){
        parameters.carriageNum = ""
        parameters.deviceNum = ""
        parameters.measuredThickness = false
        parameters.measuredChangeNum = 0
        parameters.measuredHeightBefore = -1
        parameters.measuredHeightAfter = -1
        parameters.measuredDeviceHeight = 0.0
        parameters.measuredRailHeight = 0.0
    }
}


struct RailControlView: View{
    @EnvironmentObject var parameters: AppParameters
    @State var isHit: Bool = false
    @State var Hint1: String = "瞄準鐵軌正中央"
    @State var Hint2: String = "保持40cm以上距離"
    
    @Binding var isRailFinished: Bool
    @Binding var isPassed: Bool
    
    
    
    @State var stage = step.castRay
    @State var FeatureFinish: Bool = false

    enum step {
        case castRay
        case featurePoint
    }

    var body: some View
    {
        VStack{
            Text(Hint2).foregroundColor(.white).font(.title3).padding()
            Text(Hint1).foregroundColor(.white).font(.title)
            HStack
            {
                switch stage{
                case .castRay:
                    if isHit{
                        //X Button
                        Button(action:
                                {
                            print("DEBUG: Cancel chosen device point.")
                            arViewContainer.arView.resetAPoint(name: "Rail")
                            Hint1 = "瞄準鐵軌正中央"
                            Hint2 = "保持40cm以上距離"
                            isHit = false
                        })
                        {Image(systemName: "xmark").foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .font(.title)
                                .background(Color.red)
                                .opacity(0.85)
                                .cornerRadius(30)
                                .padding(20)
                        }
                        
                        //V Button
                        Button(action: {
                            self.stage = step.featurePoint
                            Hint1 = "瞄準鐵軌中央"
                            Hint2 = "盡可能接近鐵軌"
                        }
                        )
                        {Image(systemName: "checkmark").foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .font(.title)
                                .background(isHit ? Color.green : Color.gray)
                                .opacity(0.85)
                                .cornerRadius(30)
                                .padding(20)
                        }.disabled(!isHit)
                    }
                    else{
                        Button(action: castRay)
                        {Image(systemName: "camera.metering.spot").foregroundColor(.white)
                                .frame(width: 130, height: 60)
                                .font(.title)
                                .background(Color.blue)
                                .opacity(0.85)
                                .cornerRadius(10)
                                .padding(20)
                        }
                    }
                    
                case .featurePoint:
                    
                    //Minus Button
                    Button(action:
                    {
                        print("DEBUG: Cancel chosen feature point.")
//                        arViewContainer.arView.resetAPoint(name: "Device")
                        arViewContainer.arView.resetAllCheckPointRail()
                        arViewContainer.arView.resetAPoint(name: "Rail")
                        Hint1 = "瞄準鐵軌正中央"
                        Hint2 = "保持40cm以上距離"
                        isHit = false
                        self.stage = step.castRay
                    })
                    {Image(systemName: "arrowshape.turn.up.backward").foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .font(.title)
                            .background(Color.red)
                            .opacity(0.85)
                            .cornerRadius(30)
                            .padding(20)
                    }
                    
                    //Feature
                    Button(action:featurePoint)
                    {Image(systemName: "camera.metering.spot").foregroundColor(.white)
                            .frame(width: 130, height: 60)
                            .font(.title)
                            .background(Color.blue)
                            .opacity(0.85)
                            .cornerRadius(10)
                            .padding(20)
                    }
                    
                    //Plus Button
                    Button(action: {
                        isPassed = self.safeAndCalculate()
                        isRailFinished=true
                        arViewContainer.arView.resetAPoint(name: "Rail")
                        arViewContainer.arView.resetAllCheckPointRail()
                    }
                    )
                    {Image(systemName: "checkmark").foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .font(.title)
                            .background(FeatureFinish ? Color.green : Color.gray)
                            .opacity(0.85)
                            .cornerRadius(30)
                            .padding(20)
                    }.disabled(!FeatureFinish)
                }
            }
        }.position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*7.5)
    }

    
    func castRay()
    {
        isHit = arViewContainer.arView.castRayToRailThree()
        if isHit {
            print("DEBUG: Success to hit.")
            haptic()
            Hint1 = "Cancel or Continue"
            Hint2 = "確認綠色的點位於鐵軌中央之表面附近"
            // Change View
            return
        }
        else{
            //isHit == false
            print("DEBUG: Fall to hit.")
            //Not change View
            Hint1 = "Please Try Again"
            Hint2 = "保持40cm以上距離"
            return
        }
    }
    
    func featurePoint()
    {
//        isHit = arViewContainer.arView.castRayToDevice()
        let passed = arViewContainer.arView.FeaturePointToRail()
        
        if passed {
            print("DEBUG: Success to hit.")
            haptic()
            Hint1 = "Cancel or Continue"
            Hint2 = "確認粉色的點散佈於鐵軌中央"
            // Change View
        }
        else{
            //isHit == false
            print("DEBUG: Fall to hit.")
            //Not change View
            Hint1 = "盡可能接近鐵軌"
            Hint2 = "確認粉色的點散佈於鐵軌中央"
        }
        self.FeatureFinish = passed
    }
    
    func safeAndCalculate() -> Bool{
        
        parameters.measuredRailHeight = arViewContainer.arView.SafeRailHeight()
        print(parameters.measuredRailHeight) 
        let height = (parameters.measuredDeviceHeight - parameters.measuredRailHeight)*100
        print("Height: \(height)")
        if (parameters.StandardHeightLower < height) && (height < parameters.StandardHeightHigher) {
            print("Pass!")
            return true
        }
        else{
            print("Not Pass! \(parameters.StandardHeightLower) \(height) \(parameters.StandardHeightLower < height)")
            return false
        }
    }
    
    
    func haptic()
    {
        let generator =  UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
}

public func toggleTorch(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    
    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            
            if on == true {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }
}
