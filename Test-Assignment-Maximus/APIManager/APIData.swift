//
//  APIData.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 04.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import Foundation


struct APIData: Codable {
    let current_page: Int
    let data: [myData]
}

struct myData: Codable {
    let id: Int
    let image_1: String
}
