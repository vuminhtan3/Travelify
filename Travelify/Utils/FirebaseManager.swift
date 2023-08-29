//
//  FirebaseManager.swift
//  Travelify
//
//  Created by Minh Tan Vu on 29/08/2023.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()

    private let database = Database.database().reference()

    func fetchPlaces(completion: @escaping ([Place]?) -> Void) {
        database.child("places").observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let placesResponse = try JSONDecoder().decode(PlaceResponse.self, from: jsonData)
                    let places = placesResponse.places.map { $0.value }
                    completion(places)
                } catch {
                    print("Error decoding places data:", error)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}
