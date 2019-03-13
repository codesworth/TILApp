import Vapor
import FluentSQLite



final class Category:Codable{
    
    var id:Int?
    
    var name:String
}



extension Category:SQLiteModel{}
extension Category:Content{}
extension Category:Migration{}
extension Category:Parameter{}

extension Category{
    
    var acronyms:Siblings<Category,Acronyms,AcronymCategoryPivot>{
        return siblings()
    }
}
