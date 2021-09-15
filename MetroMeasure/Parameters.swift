//
//  Parameters.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import Foundation
import SwiftUI

class AppParameters: ObservableObject{
    @Published var measuredHeight: Float = 0
    @Published var papers: [Paper] = [
        Paper(groupNum: "102", paperNum: "W0502698", startDate: .init() , operatorName: "Paul",
              Carriages: [Carriage(carriageNum: "1102",
                                   Devices: [Device(deviceNum: "L1", thicknessIsQualified: true, changeNum: nil, heightBefore: 23.1, heightAfter: nil),
                                             Device(deviceNum: "L2", thicknessIsQualified: true, changeNum: nil, heightBefore: 24.6, heightAfter: nil),
                                             Device(deviceNum: "R1", thicknessIsQualified: false, changeNum: 2, heightBefore:21.5 , heightAfter: nil),
                                             Device(deviceNum: "R2", thicknessIsQualified: true, changeNum: nil, heightBefore: 26.5, heightAfter: 23.4)]),
                          Carriage(carriageNum: "1202",
                                               Devices: [Device(deviceNum: "L1", thicknessIsQualified: true, changeNum: nil, heightBefore: 23.1, heightAfter: nil),
                                                         Device(deviceNum: "L2", thicknessIsQualified: true, changeNum: nil, heightBefore: 24.6, heightAfter: nil),
                                                         Device(deviceNum: "R1", thicknessIsQualified: false, changeNum: 2, heightBefore:21.5 , heightAfter: nil),
                                                         Device(deviceNum: "R2", thicknessIsQualified: true, changeNum: nil, heightBefore: 26.5, heightAfter: 23.4)])]
              ,isSafed: false),
        Paper(groupNum: "103", paperNum: "W0502100", startDate: .init() , operatorName: "Emily",
              Carriages: [Carriage(carriageNum: "1102",
                                   Devices: [Device(deviceNum: "L1", thicknessIsQualified: true, changeNum: nil, heightBefore: 23.1, heightAfter: nil),
                                             Device(deviceNum: "L2", thicknessIsQualified: true, changeNum: nil, heightBefore: 24.6, heightAfter: nil),
                                             Device(deviceNum: "R1", thicknessIsQualified: false, changeNum: 2, heightBefore:21.5 , heightAfter: nil),
                                             Device(deviceNum: "R2", thicknessIsQualified: true, changeNum: nil, heightBefore: 26.5, heightAfter: 23.4)])]
              ,isSafed: false),
    ]
}
