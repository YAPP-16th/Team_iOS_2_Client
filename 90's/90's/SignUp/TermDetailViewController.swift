//
//  TermDetailViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/18.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class TermDetailViewController: UIViewController {
    var index: Int!
    
    @IBOutlet weak var termImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        switch index {
        case 0:
            termImageView.image = UIImage(named: "accessTerms")
            viewHeightConst.constant = 5616
            break
        case 1:
            termImageView.image = UIImage(named: "personalData")
            viewHeightConst.constant = 2456
            break
        case 2:
            termImageView.image = UIImage(named: "confirmAge")
            viewHeightConst.constant = 800
            break
        default:
            break
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
