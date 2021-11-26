//
//  MeasureDeviceHeight.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/11/5.
//

import Foundation
import SwiftUI
import AVFoundation

struct MeasureDeviceHeight: View {
    
    @EnvironmentObject var parameters: AppParameters
    @Binding var isDeviceFinished: Bool
    
    
    var body: some View {
        ZStack(alignment: .center){
            HStack{
                Image(systemName: "equal")
                Image(systemName: "equal")
                Image(systemName: "plus")
                Image(systemName: "equal")
                Image(systemName: "equal")
            }.foregroundColor(.yellow)
                .frame(width: 50, height: 100)
                .position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*4.7)
            
            DeviceControlView(isDeviceFinished: $isDeviceFinished)
        }.navigationBarHidden(true)
    }
}


struct DeviceControlView: View
{
    @EnvironmentObject var parameters: AppParameters
    @State var isHit: Bool = false
    @State var Hint: String = "Cast Ray at Device"
    @Binding var isDeviceFinished: Bool
    
    @State private var flashlight = false
    
    @State var stage = step.castRay
    @State var FeatureFinish: Bool = false

    enum step {
        case castRay
        case featurePoint
    }
    
    
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
                switch stage{
                case .castRay:
                    if isHit{
                        //Minus Button
                        Button(action:
                                {
                            print("DEBUG: Cancel chosen device point.")
                            arViewContainer.arView.resetAPoint(name: "Device")
                            Hint = "Cast Ray at Device"
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
                        
                        //Plus Button
                        Button(action: {
                            self.stage = step.featurePoint
                            Hint = "Focus Edge & Capture"
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
                        arViewContainer.arView.resetAllCheckPoint()
                        Hint = "Focus Edge & Capture"
                    })
                    {Image(systemName: "xmark").foregroundColor(.white)
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
                        self.safeAndCalculate()
                        isDeviceFinished=true
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
//        isHit = arViewContainer.arView.castRayToDevice()
        let passed = arViewContainer.arView.castRayToDevice()

        if passed {
            print("DEBUG: Success to hit.")
            haptic()
            Hint = "Cancel or Continue"
        }
        else{
            //isHit == false
            print("DEBUG: Fall to hit.")
            //Not change View
            Hint = "Please Try Again"
        }
        isHit = passed
        return
    }
    
    func featurePoint()
    {
//        isHit = arViewContainer.arView.castRayToDevice()
        let passed = arViewContainer.arView.FeaturePointToDevice()
        
        if passed {
            print("DEBUG: Success to hit.")
            haptic()
            Hint = "Cancel or Continue"
            // Change View
        }
        else{
            //isHit == false
            print("DEBUG: Fall to hit.")
            //Not change View
            Hint = "Please Try Again"
        }
        self.FeatureFinish = passed
    }
    
    
    func safeAndCalculate(){
        parameters.measuredDeviceHeight = arViewContainer.arView.SafeDeviceHeight()
        print("Device: \(parameters.measuredDeviceHeight)")
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



