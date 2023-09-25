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
    private init() {}
    
    private let databaseRef = Database.database().reference()
    
    var listPlaces: [Place] = []
    var loadingHandler: ((Bool) -> Void)?
    
    /*
    func fetchPlacesData() {
        loadingHandler?(true) // Hiển thị loading indicator
        
        databaseRef.child("places").observeSingleEvent(of: .value) { [weak self] snapshot, error in
            guard let self = self else { return }
            
            self.loadingHandler?(false) // Ẩn loading indicator khi tải xong
            
            if let error = error {
                print("😒Error fetching places data: \(error)")
                return
            }
            
            guard let placesData = snapshot.value as? [String: [String: Any]] else {
                print("Error when mapping data")
                return
            }
            
            var fetchedData: [Place] = []
            for (_, placeDict) in placesData {
                if let placeID = placeDict["id"] as? String,
                   let placeName = placeDict["name"] as? String,
                   let location = placeDict["location"] as? String,
                   let lat = placeDict["lat"] as? Double,
                   let long = placeDict["long"] as? Double,
                   let avatar = placeDict["avatar"] as? String,
                   let rating = placeDict["rating"] as? Double,
                   let description = placeDict["description"] as? String,
                   let url = placeDict["url"] as? String,
                   let photoArray = placeDict["photos"] as? [String],
                   let reviewsDict = placeDict["reviews"] as? [[String: Any]] {
                    
                    var reviewArray: [Review] = []
                    for reviewDict in reviewsDict {
                        if let reviewID = reviewDict["id"] as? Int,
                           let ownerName = reviewDict["ownerName"] as? String,
                           let rating = reviewDict["rating"] as? Double,
                           let title = reviewDict["title"] as? String,
                           let content = reviewDict["content"] as? String,
                           let createdAt = reviewDict["createdAt"] as? String,
                           let like = reviewDict["like"] as? Int,
                           let dislike = reviewDict["dislike"] as? Int {
                            
                            let review = Review(id: reviewID, ownerName: ownerName, rating: rating, title: title, content: content, createdAt: createdAt, like: like, dislike: dislike)
                            reviewArray.append(review)
                        }
                    }
                    
                    let place = Place(id: placeID, name: placeName, location: location, lat: lat, long: long, avatar: avatar, rating: rating, description: description, url: url, photos: photoArray, reviews: reviewArray)
                    
                    fetchedData.append(place)
                }
                
                self.listPlaces = fetchedData
            }
        }
    }
     */
    
    func fetchPlacesData(completion: @escaping ([Place]) -> Void) {
        loadingHandler?(true)
        databaseRef.child("places").observeSingleEvent(of: .value) { [weak self] snapshot, error in
            guard let self = self else { return }
            self.loadingHandler?(false)
            // Xử lý lấy dữ liệu từ Firebase và cập nhật listPlaces
            if let error = error {
                print("😒Error fetching places data: \(error)")
                completion([])
                return
            }
            
            guard let placesData = snapshot.value as? [String: [String: Any]] else {
                print("Error when mapping data")
                completion([])
                return
            }
            
            var fetchedData: [Place] = []
            for (_, placeDict) in placesData {
                // Xử lý dữ liệu và tạo các đối tượng Place
                if let placeID = placeDict["id"] as? String,
                   let placeName = placeDict["name"] as? String,
                   let location = placeDict["location"] as? String,
                   let lat = placeDict["lat"] as? Double,
                   let long = placeDict["long"] as? Double,
                   let avatar = placeDict["avatar"] as? String,
                   let rating = placeDict["rating"] as? Double,
                   let description = placeDict["description"] as? String,
                   let url = placeDict["url"] as? String,
                   let photoArray = placeDict["photos"] as? [String],
                   let reviewsDict = placeDict["reviews"] as? [[String: Any]] {
                    
                    var reviewArray: [Review] = []
                    for reviewDict in reviewsDict {
                        if let reviewID = reviewDict["id"] as? Int,
                           let ownerName = reviewDict["ownerName"] as? String,
                           let rating = reviewDict["rating"] as? Double,
                           let title = reviewDict["title"] as? String,
                           let content = reviewDict["content"] as? String,
                           let createdAt = reviewDict["createdAt"] as? String,
                           let like = reviewDict["like"] as? Int,
                           let dislike = reviewDict["dislike"] as? Int {
                            
                            let review = Review(id: reviewID, ownerName: ownerName, rating: rating, title: title, content: content, createdAt: createdAt, like: like, dislike: dislike)
                            reviewArray.append(review)
                        }
                    }
                    
                    let place = Place(id: placeID, name: placeName, location: location, lat: lat, long: long, avatar: avatar, rating: rating, description: description, url: url, photos: photoArray, reviews: reviewArray)
                    
                    // Thêm Place vào mảng fetchedData
                    fetchedData.append(place)
                }
                
                self.listPlaces = fetchedData
                completion(fetchedData)
            }
        }
    }
}

