//
//  Parameters.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import Foundation
import SwiftUI

class AppParameters: ObservableObject{
//    @Published var paper: Paper
//    @Published var carriage: Carriage

    
    @Published var measuredDeviceHeight: Float = 0
    @Published var measuredRailHeight: Float = 0
    
    @Published var carriageNum: String = ""
    @Published var deviceNum: String = ""
    @Published var measuredThickness: Bool = true
    @Published var measuredChangeNum: Int = 0
    @Published var measuredHeightBefore: Float = -1
    @Published var measuredHeightAfter: Float = -1

    @Published var StandardHeightLower: Float = 10.0 //(230-2)/10
    @Published var StandardHeightHigher: Float = 100.0 //(230+2)/10

    @Published var paper: Paper = Paper(groupNum: "", paperNum: "", startDate: .init(), operatorName: "")
    @Published var carriage: Carriage = Carriage(carriageNum: "", deviceNum: "")
    
    


//    @Published var papers: [Paper] = [
//        Paper(groupNum: "102", paperNum: "W0502698", startDate: .init() , operatorName: "Paul",
//              Carriages: [Carriage(carriageNum: "1102",
//                                   Devices: [Device(deviceNum: "L1", thicknessIsQualified: true, changeNum: nil, heightBefore: 23.1, heightAfter: -1),
//                                             Device(deviceNum: "L2", thicknessIsQualified: true, changeNum: nil, heightBefore: 24.6, heightAfter: -1),
//                                             Device(deviceNum: "R1", thicknessIsQualified: false, changeNum: 2, heightBefore:21.5 , heightAfter: -1),
//                                             Device(deviceNum: "R2", thicknessIsQualified: true, changeNum: nil, heightBefore: 26.5, heightAfter: 23.4)]),
//                          Carriage(carriageNum: "1202",
//                                               Devices: [Device(deviceNum: "L1", thicknessIsQualified: true, changeNum: nil, heightBefore: 23.1, heightAfter: -1),
//                                                         Device(deviceNum: "L2", thicknessIsQualified: true, changeNum: nil, heightBefore: 24.6, heightAfter: -1),
//                                                         Device(deviceNum: "R1", thicknessIsQualified: false, changeNum: 2, heightBefore:21.5 , heightAfter: -1),
//                                                         Device(deviceNum: "R2", thicknessIsQualified: true, changeNum: nil, heightBefore: 26.5, heightAfter: 23.4)])]
//              ,isSafed: false),
//        Paper(groupNum: "103", paperNum: "W0502100", startDate: .init() , operatorName: "Emily",
//              Carriages: [Carriage(carriageNum: "1102",
//                                   Devices: [Device(deviceNum: "L1", thicknessIsQualified: true, changeNum: nil, heightBefore: 23.1, heightAfter: -1),
//                                             Device(deviceNum: "L2", thicknessIsQualified: true, changeNum: nil, heightBefore: 24.6, heightAfter: -1),
//                                             Device(deviceNum: "R1", thicknessIsQualified: false, changeNum: 2, heightBefore:21.5 , heightAfter: -1),
//                                             Device(deviceNum: "R2", thicknessIsQualified: true, changeNum: nil, heightBefore: 26.5, heightAfter: 23.4)])]
//              ,isSafed: false),
//    ]
}
