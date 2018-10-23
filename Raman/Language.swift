//
//  Language.swift
//  Raman
//
//  Created by Denis Ricard on 2018-06-26.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import UIKit

struct Language {
    var locale: String = Locale.current.identifier
    
    func representation() -> String {
        return String(reflecting: locale)
    }
}

extension Language {
//    static let mock = Language(locale: "fr_FR")
    static let mock = Language(locale: "en_EN")

}
