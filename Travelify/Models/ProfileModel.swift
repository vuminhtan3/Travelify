//
//  ProfileModel.swift
//  Travelify
//
//  Created by Minh Tan Vu on 10/08/2023.
//

import Foundation

struct UserProfile: Codable {
    var id: String?
    var name: String?
    var gender: String?
    var age: Int?
    var email: String
    var address: String?
    var phoneNumber: String?
    var bio: String?
    var avatar: String?
    var favorited: [String]?
    var searchHistory: [String]?
}

