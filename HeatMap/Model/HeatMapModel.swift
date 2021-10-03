//
//  HeatMapModel.swift
//  HeatMap
//
//  Created by Nicky on 24/09/21.
//

import Foundation
import UIKit

struct HeatMapModel : Codable {
    var Short         : String?
    var Long          : String?
    var LongUnwinding : String?
    var ShortCovering : String?
    
    enum CodingKeys : String, CodingKey {
        case Short         = "s"
        case Long          = "l"
        case LongUnwinding = "lu"
        case ShortCovering = "sc"
    }
}


struct ColorPoint {
    let color: UIColor?
    let value: CGFloat?
}

