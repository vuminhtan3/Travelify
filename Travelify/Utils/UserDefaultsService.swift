//
//  UserDefaultsService.swift
//  Travelify
//
//  Created by Minh Tan Vu on 20/07/2023.
//

import Foundation

class UserDefaultsService {
    /**
     Declare an instance of class
     */
    static var shared = UserDefaultsService()
    
    /**
     Dat ten bien
     */
    private var standard = UserDefaults.standard
    
    private enum Keys: String {
        case kCompletedOnboarding
    }
    /**
     Prevent declare second instance of class from outside
     */
    private init() {
    }
    
    /**
     completedOnboarding check xem user da hoan thanh onboarding hay chua
     
     KVO - Key value observer
     */
    
    var completedOnboarding: Bool {
        /**
         get la khi lay ra gia tri cua bien bang UserDefaultsService.shared.completedOnboarding
         */
        get {
            return standard.bool(forKey: Keys.kCompletedOnboarding.rawValue)
        }
        /**
         Hàm set được gọi khi gán giá trị cho biến UserDefaultsService.shared.completedOnboarding = true
         */
        set {
            standard.set(newValue, forKey: Keys.kCompletedOnboarding.rawValue)
            standard.synchronize()
        }
    }
    
    func clearAll() {
        standard.removeObject(forKey: Keys.kCompletedOnboarding.rawValue)
    }
    
}
