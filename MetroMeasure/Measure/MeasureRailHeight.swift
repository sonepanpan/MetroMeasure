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
    @State var isFinished: Bool = false
    @State var isPassed: Bool = false
    
    @Binding var showScanView: Bool
    @Binding var safeNum: Int
    @Binding var isHeightPassed: Bool
    
    
    var body: some View {
        ZStack(alignment: .center){
            Image(systemName: "minus")
                .foregroundColor(.yellow)
                .position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*4.7)
            
            if isFinished{
                RailResultView(isFinished: $isFinished, showScanView: $showScanView, isHeightPassed: $isHeightPassed, isPassed: $isPassed, safeNum: $safeNum)
            }
            else{
                RailControlView(isFinished: $isFinished, isPassed: $isPassed)
            }
        }.navigationBarHidden(true)
    }
}



struct RailResultView: View {
    
    @EnvironmentObject var parameters: AppParameters
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var isFinished: Bool
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
    @State var Hint: String = "Cast Ray at Rail"
    @Binding var isFinished: Bool
    @Binding var isPassed: Bool
    
    @State private var flashlight = false
    
    
    //    @Binding var IsPlacementEnabled: Bool
    //    @Binding var SelectedModel: Model?
    //    @Binding var ModelConfirmedForPlacement: Model?
    var body: some View
    {
        VStack{
            Toggle("Need Some Light?", isOn: $flashlight).foregroundColor(.white).onChange(of: flashlight, perform: { value in
                if flashlight{
                    toggleTorch(on: true)
                }
                else{
                    toggleTorch(on: false)
                }
            }).frame(width: 250, height: 30, alignment: .center)
            Text(Hint).foregroundColor(.white).font(.largeTitle)
            HStack
            {
                if isHit
                {
                    //Cancel Button
                    Button(action:
                            {
                        print("DEBUG: Cancel chosen point.")
                        Hint = arViewContainer.arView.resetAPoint(name: "Rail")
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
                    
                    //Confirm Button
                    Button(action: {
                        isFinished = true
                        isPassed = safeAndCalculate()
                    }
                    )
                    {Image(systemName: "checkmark").foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .font(.title)
                            .background(Color.green)
                            .opacity(0.85)
                            .cornerRadius(30)
                            .padding(20)
                    }
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
            }
        }.position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*7.5)
    }
    
    func castRay()
    {
        isHit = arViewContainer.arView.castRayToRail()
        if isHit {
            print("DEBUG: Success to hit.")
            haptic()
            Hint = "Cancel or Continue"
            // Change View
            return
        }
        else{
            //isHit == false
            print("DEBUG: Fall to hit.")
            //Not change View
            Hint = "Please Try Again"
            return
        }
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
