//
//  OnboardingViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 07/07/2023.
//

import UIKit


struct Onboarding {
    let image: String
    let title: String
    let description: String
}

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var datasource = [Onboarding]()
    private var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        datasource = [
        Onboarding(image: "onboarding4", title: "Hãy khám phá thế giới", description: "Hãy cùng chúng tôi khám phá thế giới chỉ với một vài thao tác đơn giản"),
        Onboarding(image: "onboarding3", title: "Tham quan các điểm du lịch", description: "Hàng ngàn điểm du lịch đã sẵn sàng cho bạn đặt chân tới và khám phá"),
        Onboarding(image: "onboarding7", title: "Sẵn sàng cho chuyến đi sắp tới của bạn", description: "Hãy bắt đầu khám phá những vùng đất mới, tất cả đã sẵn sàng")
        ]
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Đăng ký custom collection view cell
        collectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.backgroundColor = .white
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            flowLayout.estimatedItemSize = .zero
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            flowLayout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
}

//MARK: - Datasource Methods
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        let onboardingModel = datasource[indexPath.row]
        
        cell.bindData(index: indexPath.row,
                      image: onboardingModel.image,
                      title: onboardingModel.title,
                      description: onboardingModel.description) { [weak self] in
            guard let self = self else {return}
            
            if indexPath.row + 1 == self.datasource.count {
                UserDefaults.standard.setValue(true, forKey: "isCompletedOnboarding")
                
//                print("index: \(indexPath.row), currentPage: \(self.currentPage)")
            } else {
                self.currentPage = indexPath.row + 1
                self.collectionView.isPagingEnabled = false
                self.collectionView.scrollToItem(at: IndexPath(row: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
                self.collectionView.isPagingEnabled = true
            }
        }
        return cell
    }
}


//MARK: - Delegate Methods

extension OnboardingViewController: UICollectionViewDelegate {
    
}
