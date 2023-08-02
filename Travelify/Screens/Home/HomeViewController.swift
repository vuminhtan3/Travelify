//
//  HomeViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 30/07/2023.
//

import UIKit

struct Suggestion {
    let backgroundImg: String
    let name: String
    let location: String
}

struct HighRating {
    let image: String
    let name: String
    let location: String
    let description: String
}

class HomeViewController: UIViewController {

    @IBOutlet weak var greetingLb: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    @IBOutlet weak var highRatingTableView: UITableView!
    
    private var suggestionDatasource = [Suggestion]()
    private var highRatingDatasource = [HighRating]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        avatarImgView.layer.cornerRadius = avatarImgView.frame.height/2

        setupCollectionView()
        setupTableView()
        
        suggestionDatasource = [
        Suggestion(backgroundImg: "SaPa", name: "SaPa", location: "Lào Cai"),
        Suggestion(backgroundImg: "HaGiang2", name: "Hà Giang", location: "Hà Giang"),
        Suggestion(backgroundImg: "BaNaHills", name: "Bà Nà Hills", location: "Đà Nẵng"),
        Suggestion(backgroundImg: "CauVang2", name: "Cầu Vàng", location: "Đà Nẵng")
        ]
        
        highRatingDatasource = [
            HighRating(image: "HaGiang", name: "Hà Giang", location: "Hà Giang", description: "Hà Giang là tỉnh toạ lạc tại cực Bắc Việt Nam với phía Đông giáp Cao Bằng, phía Tây giáp Yên Bái - Lào Cao. phía Nam giáp Tuyên Quang và phía Bắc giáp Trung Quốc. Trung tâm của tỉnh là thành phố Hà Giang nằm cách Hà Nội khoảng 320km. Điểm thu hút của Hà Giang đến từ cảnh quan thiên nhiên tuyệt đẹp với nhiều thắng cảnh như đỉnh Mã Pí Lèng, hẻm vực Tu Sản, núi đôi Quản Bạ,... Chính vì thế mà dù sở hữu địa hình hiểm trở, nhưng Hà Giang vẫn thu hút được rất nhiều du khách ghé thăm."),
            HighRating(image: "SaPa", name: "SaPa", location: "Lào Cai", description: "Sapa là một địa điểm du lịch nổi tiếng thuộc tỉnh Lào Cai, nằm tại phía Bắc của nước ta. Nhờ được tạo hóa ưu ái mà thiên nhiên Sapa hiện lên như một bức tranh tiên cảnh đầy tráng lệ nhưng cũng không kém phần thơ mộng.\nTừ nơi đây nhìn ra bốn bể xung quanh đều là mây trắng xóa, núi non trùng điệp vờn mây ghẹo gió, hàng thông già vững chãi như đã quá quen với cảnh tượng trước mắt, phía xa hơn lại là những ruộng lúa bậc thang vàng ươm báo hiệu một vụ mùa “no đủ”."),
            HighRating(image: "Fansipan", name: "Đỉnh Fansipan", location: "Lào Cai", description: """
                Fansipan là ngọn núi cao nhất Việt Nam, đồng thời cũng là ngọn núi cao nhất trong ba nước Đông Dương luôn, nên được mệnh danh là ""Nóc nhà Đông Dương"". Ngọn núi Fansipan cao 3.143 m so với mặt nước biển, nằm ở trung tâm dãy Hoàng Liên Sơn, ở vị trí giáp giữa tỉnh Lai Châu và Lào Cai. Cuồng biết là nhiều bạn đi du lịch Sapa thường thuê khách sạn nghỉ ngơi tại trung tâm thị trấn, nên Cuồng tìm hiểu khoảng cách đường đi giúp bạn luôn: núi Fansipan cách thị trấn Sapa 9 km về phía Tây Nam.\nVới chiều dài 280 km từ Phong Thổ đến Hòa Bình, chiều ngang chân núi Hoàng Liên Sơn rộng nhất khoảng 75km, hẹp nhất là 45km, gồm ba khối, khối Bạch Mộc Lương Tử, khối Fansipan và khối Pú Luông. Cả mái nhà đồ sộ này ẩn chứa bao điều kỳ lạ, nhưng kỳ lạ và bí ẩn nhất, đồng thời thu hút khát khao chinh phục của nhiều nhà leo núi nhất chính là đỉnh Fansipan.\nDưới chân núi là những cây gạo, cây mít, cây cơi với mật độ khá dầy tạo nên những địa danh Cốc Lếu (Cốc Gạo), Cốc San (Cốc Mít)… Vì núi Fansipan có độ cao tới hơn 3.000 m nên khi leo núi, bạn sẽ được trải qua nhiều vành đai thời tiết rất khác nhau luôn.
                """)
        ]
    }

    
    private func setupCollectionView() {
        suggestCollectionView.delegate = self
        suggestCollectionView.dataSource = self
        suggestCollectionView.register(UINib(nibName: "SuggestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestCollectionViewCell")
        
        if let flowLayout = suggestCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 0
            
            flowLayout.estimatedItemSize = .zero
            flowLayout.itemSize = CGSize(width: 130, height: suggestCollectionView.frame.height)
            flowLayout.scrollDirection = .horizontal
        }
        
        suggestCollectionView.showsHorizontalScrollIndicator = false
//        self.suggestCollectionView.reloadData()
    }
    
    private func setupTableView() {
        highRatingTableView.delegate = self
        highRatingTableView.dataSource = self
        highRatingTableView.register(UINib(nibName: "HighRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "HighRatingTableViewCell")
        self.highRatingTableView.reloadData()
    }

}


//MARK: - CollectionView Datasource methods
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestionDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = suggestCollectionView.dequeueReusableCell(withReuseIdentifier: "SuggestCollectionViewCell", for: indexPath) as! SuggestCollectionViewCell
        cell.layer.cornerRadius = 10
        
        let suggestionModel = suggestionDatasource[indexPath.row]
        cell.bindData(name: suggestionModel.name, location: suggestionModel.location, backgroundImage: suggestionModel.backgroundImg)
        return cell
        
    }
    
    
}

//MARK: - CollectionView Delegate Methods
extension HomeViewController: UICollectionViewDelegate {
    
}

//MARK: - TableView HighRating Datasource Methods
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highRatingDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = highRatingTableView.dequeueReusableCell(withIdentifier: "HighRatingTableViewCell", for: indexPath) as! HighRatingTableViewCell
        cell.layer.cornerRadius = 5
        
        let highRatingModel = highRatingDatasource[indexPath.row]
        cell.binData(image: highRatingModel.image, name: highRatingModel.name, location: highRatingModel.location, description: highRatingModel.description) {
            print("Favorite button tapped")
        }
        
        return cell
        
    }
    
    
}

//MARK: - TableView HighRating Delegate Methods
extension HomeViewController: UITableViewDelegate {
    
}
