//
//  GetOrderResult.swift
//  90's
//
//  Created by 홍정민 on 2020/05/30.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

struct GetOrderResult: Codable {
    let uid:Int
    let album:album
    let paperType1:PaperType
    let postType:PostType
    let cost:String
    let amount:Int
    let orderCode: String
    var recipient:String
    var address: String
    var addressDetail: String
    var phoneNum: String
    var message: String
    var postalCode:String
    var trackingNum:String?
}

struct PaperType: Codable {
    let uid:Int
    let type:String
}

struct PostType: Codable {
    let uid:Int
    let type:String
}




//앨범 커버 이미지 album
//앨범 커버 이름 album
//앨범 이름 album
//사진 레이아웃 album
//인화용지 paperType1
//배송타입 postType
//가격 cost
//수량 amount
//주문번호 orderCode
//수령인 recipient
//배송지 address, addressDetail
//연락처 phoneNum
//배송메모 message
//송장번호 (shipping이상의 상태일때)  trackingNum
//앨범 uid album
