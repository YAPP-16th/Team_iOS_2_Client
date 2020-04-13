//
//  Protocol.swift
//  90's
//
//  Created by 성다연 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//


protocol ContentslabelProtocol {
    var title : String {get}
    var titleFont : UIFont {get}
    var titleColor : UIColor {get}
}

protocol TitlelabelProtocol {
    var title : String {get}
    var titleFont : UIFont {get}
    var titleColor : UIColor {get}
}

extension ContentslabelProtocol {
    var titleColor : UIColor {
        return .black
    }
    var titleFont : UIFont {
        return .systemFont(ofSize: 21)
    }
}

extension TitlelabelProtocol {
    var titleColor : UIColor {
        return .black
    }
    var titleFont : UIFont {
        return .boldSystemFont(ofSize: 16)
    }
}
