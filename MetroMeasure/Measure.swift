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
    
    @State var isScanned = false
    @State var isThicknessFinished = false
    @State var isFinished: Bool = false
    @State var isHeightPassed: Bool? = nil

    
    var body: some View {
        if isScanned == false{
            ScanView(isScanned: $isScanned, carriageNum: $carriageNum, deviceNum: $deviceNum)
        }
        else{
            ZStack(alignment: .center){
                arViewContainer.ignoresSafeArea()
                Image(systemName: "plus")
                    .foregroundColor(.yellow)
                    .position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*4.7)
                
                if isThicknessFinished == false{
                    thicknessView(isThicknessFinished: $isThicknessFinished)
                }
                else{
                    if isFinished{
                        ResultView(isFinished: $isFinished, showScanView: $showScanView, isHeightPassed: $isHeightPassed, carriage: Carriage(carriageNum: carriageNum, deviceNum: deviceNum))
                    }
                    
                    else{
                        ControlView(isFinished: $isFinished, isHeightPassed: $isHeightPassed)
                    }
                }
            }.navigationBarHidden(true)
        }
    }
}

struct thicknessView: View{
    @EnvironmentObject var parameters: AppParameters
    @Binding var isThicknessFinished: Bool
    
    var body: some View{
        VStack(alignment: .center){
            Toggle("Thickness Qualified?", isOn: $parameters.measuredThickness).foregroundColor(.white).onChange(of: parameters.measuredThickness, perform: { value in
                if parameters.measuredThickness{
                    parameters.measuredChangeNum = 0
                }
                else{
                    parameters.measuredChangeNum = 1
                }
            }).frame(width: 250, height: 50, alignment: .center)
            HStack{
                //Reset Button
                Button(action: {
                    if parameters.measuredChangeNum > 1{
                        parameters.measuredChangeNum -= 1
                    }
                })
                {Image(systemName: "minus").foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(parameters.measuredThickness ? Color.gray : Color.red)
                    .opacity(0.85)
                    .cornerRadius(30)
                    .padding(20)
                }.disabled(parameters.measuredThickness)
            
                Text(String(format: " %d", parameters.measuredChangeNum))
                    .frame(width: 100, height: 50, alignment: .center)
                    .font(.largeTitle)
                    .foregroundColor(.white)
//                    .padding(20)
                
                //Return to Main View
                Button(action: {
                    parameters.measuredChangeNum += 1
                })
                {Image(systemName: "plus").foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(parameters.measuredThickness ? Color.gray : Color.green)
                    .opacity(0.85)
                    .cornerRadius(30)
                    .padding(20)
                }.disabled(parameters.measuredThickness)
            }
            Button(action: {
                isThicknessFinished = true
            })
            {Image(systemName: "arrow.right").foregroundColor(.white)
                .frame(width: 130, height: 50)
                .font(.title)
                .background(Color.blue)
                .opacity(0.85)
                .cornerRadius(10)
                .padding(18)
                
            }
        }.position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*7.5)
    }

    
}


struct ResultView: View {
    
    @EnvironmentObject var parameters: AppParameters
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var isFinished: Bool
    @Binding var showScanView: Bool
    @Binding var isHeightPassed: Bool?
    
    var carriage: Carriage

    var body: some View {
        HStack(alignment: .center){
            //Reset Button
            Button(action: {
                    if isFinished{
                        arViewContainer.arView.resetAllPoint()
                        isFinished = false
                        parameters.measuredHeightBefore = (parameters.measuredHeight - parameters.measuredRailHeight)*100
                    }})
            {Image(systemName: "arrow.counterclockwise").foregroundColor(.white)
                .frame(width: 60, height: 60)
                .font(.title)
                .background(Color.blue)
                .opacity(0.85)
                .cornerRadius(30)
                .padding(20)
            }.disabled(isHeightPassed!)
        
            Text(String(format: "%.2f\n cm", (parameters.measuredHeight-parameters.measuredRailHeight)*100))
                .frame(width: 100, height: 100, alignment: .center)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(20)
            
            //Return to Main View
            Button(action: {
                showScanView = false
                arViewContainer.arView.resetAllPoint()
                parameters.measuredHeightAfter = (parameters.measuredHeight - parameters.measuredRailHeight)*100
                safeDeviceRecord()
                resetDeviceParameter()
            })
            {Image(systemName: "paperplane").foregroundColor(.white)
                .frame(width: 60, height: 60)
                .font(.title)
                .background(Color.blue)
                .opacity(0.85)
                .cornerRadius(30)
                .padding(20)
            }.disabled(!(isHeightPassed!))
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
    }
}


struct ControlView: View
{
    @EnvironmentObject var parameters: AppParameters
    @State var isHit: Bool = false
    @State var Hint: String = "Choose first point"
    @Binding var isFinished: Bool
    
    
    @State private var flashlight = false
    @Binding var isHeightPassed: Bool?

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
                                Hint = arViewContainer.arView.resetAPoint()
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
                        isHeightPassed = safeAndCalculate()
                        if arViewContainer.arView.point2 != nil {flashlight = false}
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
        isHit = arViewContainer.arView.castRay()
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
    
    func safeAndCalculate() -> Bool?{
        
        let result = arViewContainer.arView.safeAndCalculate()
        if result >= 0
        {
            parameters.measuredHeight = result
            let height = (parameters.measuredHeight - parameters.measuredRailHeight)*100
            print("Height: \(height)")
            isFinished = true
            if (parameters.StandardHeightLower < height) && (height < parameters.StandardHeightHigher) {
                print("Pass!")
                return true
            }
            else{
                print("Not Pass! \(parameters.StandardHeightLower) \(height) \(parameters.StandardHeightLower < height)")
                return false
            }
        }
        else{
            Hint = "Choose second Point"
            isHit = false
            return nil
        }
    }
    
    func haptic()
    {
        let generator =  UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    func toggleTorch(on: Bool) {
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
}

