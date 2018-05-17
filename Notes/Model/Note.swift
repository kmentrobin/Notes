//
//  Note.swift
//  Notes
//
//  Created by Robin Kment on 16.05.18.
//  Copyright © 2018 cz.robinkment. All rights reserved.
//

import Foundation

struct Note : Codable {
    var text : String
    var createdAt : Date
    var author : String
    var id : String
    
    init(text: String) {
        self.text = text
        createdAt = Date()
        author = LOGGED_USER_ID
        id = ""
    }

}
