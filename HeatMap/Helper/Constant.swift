//
//  Constant.swift
//  HeatMap
//
//  Created by Nicky on 24/09/21.
//

import Foundation
import UIKit



let jsonUrlString = "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json"
let screenHeightFactor = UIScreen.main.bounds.height/667
let screenWidthFactor = UIScreen.main.bounds.width/375


struct colorCodes {
    
    static let Long             =   UIColor.init(named: "Long")
    static let Short            =   UIColor.init(named: "Short")
    static let Long_Unwinding   =   UIColor.init(named: "LongUnwinding")
    static let Short_Covering   =   UIColor.init(named: "ShortCovering")
    
    
    static let black = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
}
