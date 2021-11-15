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
    
    @State private var flashlight = true
    
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
                        Hint = arViewContainer.arView.resetAPoint(name: "Device")
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
                        self.safeAndCalculate()
                        isDeviceFinished=true
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
//        isHit = arViewContainer.arView.castRayToDevice()
        isHit = arViewContainer.arView.FeaturePointToDevice()

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



