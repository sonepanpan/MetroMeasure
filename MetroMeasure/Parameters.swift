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
        Paper(groupNum: "102", paperNum: "W0502698", startDate: .init() , operatorName: "Paul",  Devices: nil, isSafed: false),
        Paper(groupNum: "103", paperNum: "W0502100", startDate: .init() , operatorName: "Emily",  Devices: nil, isSafed: false)
    ]
}
