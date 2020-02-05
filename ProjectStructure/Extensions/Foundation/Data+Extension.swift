//
//  Data+Extension.swift
//  ProjectStructure
//
//  Created by mac-0005 on 06/01/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import Foundation

extension Data {
    
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self,from:self)
    }
    
//    func decoded<T: Decodable>() throws -> [T] {
//        return try JSONDecoder().decode([T].self,from:self)
//    }
    
}
