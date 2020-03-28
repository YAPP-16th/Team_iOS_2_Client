import Foundation

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
    static var themeList = [Theme(index: 0, themeName: "70s", previewPhoto: "theme0", themePhoto: "theme0"),
                            Theme(index: 1, themeName: "80s", previewPhoto: "theme1", themePhoto: "theme1"),
                            Theme(index: 2, themeName: "90s", previewPhoto: "theme2", themePhoto: "theme2"),
                            Theme(index: 3, themeName: "00s", previewPhoto: "theme3", themePhoto: "theme3"),
                            Theme(index: 4, themeName: "10s", previewPhoto: "theme4", themePhoto: "theme4")]
    
}
