//
//  StickerImage.swift
//  90's
//
//  Created by 성다연 on 2020/05/22.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

enum StickerImage {
    case Basic
    case Glitter
    case Character
    case Tape
    case Words
    case Alphabet
    case Number
    
    var imageArray : [UIImage] {
        switch self {
        case .Basic : return []
        case .Glitter : return []
        case .Character : return []
        case .Tape : return []
        case .Words : return []
        case .Alphabet : return []
        case .Number : return []
        }
    }
}
