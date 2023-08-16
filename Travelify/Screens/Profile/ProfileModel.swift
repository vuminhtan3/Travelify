//
//  ProfileModel.swift
//  Travelify
//
//  Created by Minh Tan Vu on 10/08/2023.
//

import Foundation

enum Gender {
    case male
    case female
    case other
}

struct UserProfile {
    var id: String
    var name: String
    var gender: String?
    var age: Int?
    var email: String
    var address: String?
    var phoneNumber: String?
    var bio: String?
    var image: String?
}
