//
//  PlaceModel.swift
//  Travelify
//
//  Created by Minh Tan Vu on 26/08/2023.
//

import Foundation

struct Place: Codable {
    var id: String?
    var name: String?
    var location: String?
    var lat: Double?
    var long: Double?
    var avatar: String?
    var rating: Double?
    var description: String?
    var url: String?
    var photos: [String]?
    var reviews: [Review]?
}

struct Review: Codable {
    var id: Int
    var ownerName: String?
    var rating: Double?
    var title: String?
    var content: String?
    var createdAt: String?
    var like: Int?
    var dislike: Int?
}

struct Photo: Codable {
    var photo: String
}

struct PlaceResponse: Codable {
    var places: [String: Place]
}

struct VietNam {
    let vietnam_provinces = [
        "Hà Nội",
        "An Giang",
        "Bà Rịa - Vũng Tàu",
        "Bạc Liêu",
        "Bắc Kạn",
        "Bắc Giang",
        "Bắc Ninh",
        "Bến Tre",
        "Bình Dương",
        "Bình Định",
        "Bình Phước",
        "Bình Thuận",
        "Cà Mau",
        "Cao Bằng",
        "Cần Thơ",
        "Đà Nẵng",
        "Đắk Lắk",
        "Đắk Nông",
        "Điện Biên",
        "Đồng Nai",
        "Đồng Tháp",
        "Gia Lai",
        "Hà Giang",
        "Hà Nam",
        "Hà Tĩnh",
        "Hải Dương",
        "Hải Phòng",
        "Hậu Giang",
        "Hòa Bình",
        "Hồ Chí Minh",
        "Hưng Yên",
        "Khánh Hòa",
        "Kiên Giang",
        "Kon Tum",
        "Lai Châu",
        "Lâm Đồng",
        "Lạng Sơn",
        "Lào Cai",
        "Long An",
        "Nam Định",
        "Nghệ An",
        "Ninh Bình",
        "Ninh Thuận",
        "Phú Thọ",
        "Phú Yên",
        "Quảng Bình",
        "Quảng Nam",
        "Quảng Ngãi",
        "Quảng Ninh",
        "Quảng Trị",
        "Sóc Trăng",
        "Sơn La",
        "Tây Ninh",
        "Thái Bình",
        "Thái Nguyên",
        "Thanh Hóa",
        "Thừa Thiên Huế",
        "Tiền Giang",
        "Trà Vinh",
        "Tuyên Quang",
        "Vĩnh Long",
        "Vĩnh Phúc",
        "Yên Bái"
    ]
}
