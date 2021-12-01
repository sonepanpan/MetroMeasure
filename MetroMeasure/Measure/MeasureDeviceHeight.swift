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
    @State private var flashlight = false
    @Binding var isDeviceFinished: Bool
    
    
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
                    Image(systemName: "equal")
                    Image(systemName: "equal")
                    Image(systemName: "plus")
                    Image(systemName: "equal")
                    Image(systemName: "equal")
                }.foregroundColor(.yellow)
                    .frame(width: 50, height: 100)
                    .position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*3.8)
            }
            DeviceControlView(isDeviceFinished: $isDeviceFinished)
        }.navigationBarHidden(true)
    }
}


struct DeviceControlView: View
{
    @EnvironmentObject var parameters: AppParameters
    @State var isHit: Bool = false
    @State var Hint1: String = "瞄準靠近集電靴邊緣之表面"
    @State var Hint2: String = "保持40cm以上距離"
    @Binding var isDeviceFinished: Bool
    
    
    
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
                            arViewContainer.arView.resetAPoint(name: "Device")
                            Hint1 = "瞄準靠近集電靴邊緣之表面"
                            Hint2 = "保持40以上距離"
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
                            Hint1 = "瞄準集電靴之邊緣"
                            Hint2 = "盡可能接近集電靴"
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
                    
                    //X Button
                    Button(action:
                            {
                        print("DEBUG: Cancel chosen feature point.")
//                        arViewContainer.arView.resetAPoint(name: "Device")
                        arViewContainer.arView.resetAllCheckPointDevice()
                        arViewContainer.arView.resetAPoint(name: "Device")
                        Hint1 = "瞄準靠近集電靴邊緣之表面"
                        Hint2 = "保持40以上距離"
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
                        self.safeAndCalculate()
                        isDeviceFinished=true
                        arViewContainer.arView.resetAPoint(name: "Device")
                        arViewContainer.arView.resetAllCheckPointDevice()
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
        let passed = arViewContainer.arView.castRayToDeviceThree()

        if passed {
            print("DEBUG: Success to hit.")
            haptic()
            Hint1 = "Cancel or Continue"
            Hint2 = "確認綠色的點位於集電靴之表面附近"
        }
        else{
            //isHit == false
            print("DEBUG: Fall to hit.")
            //Not change View
            Hint1 = "Please Try Again"
            Hint2 = "保持40cm以上距離"
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
            Hint1 = "Cancel or Continue"
            Hint2 = "確認粉色的點散佈於集電靴之邊緣"
            // Change View
        }
        else{
            //isHit == false
            print("DEBUG: Fall to hit.")
            //Not change View
            Hint1 = "盡可能接近集電靴"
            Hint2 = "確認粉色的點散佈於集電靴之邊緣"
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



