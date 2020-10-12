//
//  PairAPIData.swift
//  Test-Assignment-Maximus
//
//  Created by iOS on 12.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import Foundation


struct PairAPIData: Codable {
    let id: Int
    let image_1: String
    let image_2: String
    let image_3: String
    let closed: Int
    let copyright: String?
}
