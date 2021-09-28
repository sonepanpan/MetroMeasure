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
    @State var isFinished: Bool = false
    
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
        
                
                if isFinished{
                    ResultView(isFinished: $isFinished, showScanView: $showScanView)
                }
                
                else{
                    ControlView(isFinished: $isFinished)
                }
            }.navigationBarHidden(true)
        }
    }
}



struct ResultView: View {
    
    @EnvironmentObject var parameters: AppParameters
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var isFinished: Bool
    @Binding var showScanView: Bool

    var body: some View {
        HStack(alignment: .center){
            //Reset Button
            Button(action: {
                    if isFinished{
                        arViewContainer.arView.resetAllPoint()
                        isFinished = false
                    }})
            {Image(systemName: "arrow.counterclockwise").foregroundColor(.white)
                .frame(width: 60, height: 60)
                .font(.title)
                .background(Color.blue)
                .opacity(0.85)
                .cornerRadius(30)
                .padding(20)
            }
        
            Text(String(format: "%.2f\ncm", parameters.measuredHeight*100))
                .frame(width: 100, height: 100, alignment: .center)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(20)
            
            //Return to Main View
            Button(action: {
                showScanView = false
                arViewContainer.arView.resetAllPoint()
            })
            {Image(systemName: "paperplane").foregroundColor(.white)
                .frame(width: 60, height: 60)
                .font(.title)
                .background(Color.blue)
                .opacity(0.85)
                .cornerRadius(30)
                .padding(20)
            }
            //SAFE BUTTON
            //            Button(action: {
            //                if isFinished{
            //                    arViewContainer.arView.resetAllPoint()
            //                    isFinished = false
            //                }})
            //                {Image(systemName: "paperplane").foregroundColor(.white)
            //                    .frame(width: 60, height: 60)
            //                    .font(.title)
            //                    .background(Color.blue)
            //                    .opacity(0.85)
            //                    .cornerRadius(30)
            //                    .padding(20)
            //                }
        }.position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*8)
    }
}


struct ControlView: View
{
    @EnvironmentObject var parameters: AppParameters
    @State var isHit: Bool = false
    @State var Hint: String = "Choose first point"
    @Binding var isFinished: Bool
    
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
                        safeAndCalculate()
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
    
    func safeAndCalculate(){
        
        let result = arViewContainer.arView.safeAndCalculate()
        if result >= 0
        {
            parameters.measuredHeight = result
            isFinished = true
        }
        else{
            Hint = "Choose second Point"
            isHit = false
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

