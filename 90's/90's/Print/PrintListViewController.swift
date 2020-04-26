//
//  PrintListViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/25.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

//Table View 들어감

class PrintListViewController: UIViewController {
    
    @IBOutlet weak var printListTableView: UITableView!
    @IBOutlet weak var gotoAlbum: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var demoAlbumImage: UIImageView!
    
    @IBOutlet weak var cautionTitle: UILabel!
    
    //아무도 없는 뷰 일때 array와 더미 array 구분해놓음
    var array : [String] = ["sweetholiday","sweetholiday","sweetholiday","sweetholiday","sweetholiday","sweetholiday","sweetholiday","sweetholiday","sweetholiday","sweetholiday",]
    
//    var array : [String] = []
    let imgIcon = UIImage(named: "90SLogo")?.withRenderingMode(.alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gotoAlbum.layer.cornerRadius = 8
        
        // iPhone X..
        if UIScreen.main.nativeBounds.height == 1792.0 {
            
            self.topConstraint.constant = 244
            
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height == 1334.0
        {
            self.topConstraint.constant = 112
            
        }
        
    self.navigationController?.navigationBar.topItem?.title = "앨범 인화"
        let barButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = barButtonItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        //        self.navigationController?.navigationBar.isHidden = false

        
        if array.count != 0 {
            demoAlbumImage.isHidden = true
            cautionTitle.isHidden = true
            gotoAlbum.isHidden = true
            printListTableView.delegate = self
            printListTableView.dataSource = self
            
        }
        else {
            
            printListTableView.isHidden = true
        }
    }
    
}

extension PrintListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = printListTableView.dequeueReusableCell(withIdentifier: "PrintListTableViewCell", for :indexPath) as! PrintListTableViewCell
        
        cell.albumImageView.image = UIImage(named: array[indexPath.row] )
        cell.albumDate.text = "20.03.25 - 20.06.25"
        cell.albumTitle.text = "경진이의 여행 앨범"
        cell.pictureCount.text = "60/60"
        cell.orderBtn.backgroundColor = .black
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.currentIndex = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 176
        
    }
}


extension PrintListViewController : ClickActionDelegate {
    
    func didClickedLink(index: Int) {
        
        print("Clicked")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
        
        vc.modalPresentationStyle = .fullScreen
        print(array[index] )
        vc.tempImage = UIImage(named: array[index] )
        self.navigationItem.title = " "
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "iconBack")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "iconBack")
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
}
