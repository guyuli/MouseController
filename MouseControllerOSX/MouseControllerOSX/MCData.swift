//
//  MCData.swift
//  MouseControllerOSX
//
//  Created by Guyu Li on 2018-09-27.
//  Copyright © 2018 Guyu Li. All rights reserved.
//

import Foundation

struct MCData : Codable {
    
    var x:Double
    var y:Double
    var scroll:Int
    var leftClicked:Bool
    var rightClicked:Bool
}
