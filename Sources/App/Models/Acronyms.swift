import FluentSQLite
import Vapor

final class Acronyms:Codable{
    var id:Int?
    var short:String
    var long:String
    
    init(short:String, long:String) {
        self.long = long
        self.short = short
    }
}



extension Acronyms:SQLiteModel{
    
//    typealias Database = SQLiteDatabase
//    typealias ID = Int
//    static let idKey:IDKey = \Acronyms.id
}

extension Acronyms:Content{}
extension Acronyms:Migration{}
