import Foundation

let ThemeDatabase : ThemeModel = ThemeModel()

class Theme {
    var index:Int!
    var themeName:String!
    var previewPhoto:String!
    var themePhoto:String!
    
    init(index : Int, themeName : String, previewPhoto:String,
         themePhoto:String) {
        self.index = index
        self.themeName = themeName
        self.previewPhoto = previewPhoto
        self.themePhoto = themePhoto
    }
}

class ThemeModel {
    var arrayList : [Theme] = []
    
    func defaultData() -> Array<Theme> {
        let stock = Theme(index: 0, themeName: "pink", previewPhoto: "dog1", themePhoto: "dog2")
        return [stock]
    }
    
    init() {
        arrayList = defaultData()
    }
}
