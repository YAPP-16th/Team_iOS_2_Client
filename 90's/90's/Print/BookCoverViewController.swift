//
//  BookCoverViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/12.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class BookCoverViewController : UIViewController {
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    
    let imageNameArray: [String] = ["cover1", "cover2","cover3","cover4","testEmpty","testEmpty"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
        self.coverImageView.image = UIImage(named: "testEmpty")
        
        self.nextBtn.backgroundColor = .lightGray
    }
    
    
    
    @IBAction func coverCheckBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
        vc.navigationItem.title = "옵션 선택"
        vc.coverImage = self.coverImageView.image
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}



extension BookCoverViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

func delegateSetting(){
    coverCollectionView.delegate = self
    coverCollectionView.dataSource = self
    
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageNameArray.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCoverCell", for: indexPath) as! BookCoverCell
    cell.coverView.image = UIImage(named: imageNameArray[indexPath.row])
    cell.coverView.contentMode = .scaleToFill
    
    return cell
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCoverCell", for: indexPath) as! BookCoverCell
    self.coverImageView.image = UIImage(named: imageNameArray[indexPath.row])
    cell.coverView.isHighlighted = true
    self.nextBtn.backgroundColor = .black

}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 117, height: 142)
}

}
