import Vapor
import FluentMySQL



final class Category:Codable{
    
    var id:Int?
    
    var name:String
}



extension Category:MySQLModel{}
extension Category:Content{}
extension Category:Migration{}
extension Category:Parameter{}

extension Category{
    
    var acronyms:Siblings<Category,Acronyms,AcronymCategoryPivot>{
        return siblings()
    }
}
