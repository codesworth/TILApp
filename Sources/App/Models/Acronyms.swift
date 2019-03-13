import FluentSQLite
import Vapor

final class Acronyms:Codable{
    var id:Int?
    var short:String
    var long:String
    var userID:User.ID
    
    init(short:String, long:String, userID:User.ID) {
        self.long = long
        self.short = short
        self.userID = userID
    }
}



extension Acronyms:SQLiteModel{
    
//    typealias Database = SQLiteDatabase
//    typealias ID = Int
//    static let idKey:IDKey = \Acronyms.id
}

extension Acronyms:Content{}
extension Acronyms:Migration{}
extension Acronyms:Parameter{}


extension Acronyms{
    
    var user:Parent<Acronyms, User>{
        return parent(\.userID)
    }
    
    var categories:Siblings<Acronyms,Category,AcronymCategoryPivot>{
        return siblings()
    }
}
