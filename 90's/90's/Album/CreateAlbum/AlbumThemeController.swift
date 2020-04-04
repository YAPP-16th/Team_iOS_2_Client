

import Foundation
import UIKit

class AlbumThemeController : UIViewController {
    var albumIndex: Int?
    
    @IBOutlet weak var themeTableView: UITableView!
    
    @IBAction func goToRoot(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        setThemeTableView()
    }
    
    func setThemeTableView(){
        themeTableView.delegate = self
        themeTableView.dataSource = self
    }
    
    
}



extension AlbumThemeController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AlbumModel.albumList[albumIndex!].selectTheme = ThemeModel.themeList[indexPath.row]
        let albumDetailVC = storyboard?.instantiateViewController(identifier: "albumDetailVC") as! AlbumDetailController
        
        albumDetailVC.albumIndex = self.albumIndex!
        
        //선택한 테마를 album에 넣어줌
        AlbumModel.albumList[albumIndex!].selectTheme = ThemeModel.themeList[indexPath.row]
        
        navigationController?.pushViewController(albumDetailVC, animated: true)
        
    }
}


extension AlbumThemeController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThemeModel.themeList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell") as! ThemeCell
        let data = ThemeModel.themeList[indexPath.row]
        cell.themeImageView.image = UIImage(named: data.previewPhoto)
        cell.themeNameLabel.text = data.themeName
        return cell
        
    }
    
    
}
