//
//  Data.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/8.
//

import Foundation

struct Papers: Decodable{
    var items: [Paper]
}

struct Paper: Decodable{
    //車組編號
    let groupNum: String
    //工單號碼
    let paperNum: String
    //實際開工日期
    let startDate: Date
    //執行人員
    let operatorName: String
//    //完工日期
//    let finishDate: Date
    
    //集電靴 4*4=16
    let Devices: [Device]?
    
    //完工日期
    
    //Bool
    let isSafed: Bool
}


struct Device: Decodable{
    //車廂編號
    let carriageNum: String
    //L1 L2 R1 R2
    let deviceNum: String
    //厚度
    let thicknessIsQualified: Bool
    //更換片數
    let changeNum: Int?
    //調整前高度
    let heightBefore: Float
    //調整後高度
    let heightAfter: Float?
}

