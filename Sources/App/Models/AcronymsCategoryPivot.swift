import FluentSQLite
import Vapor
import Foundation


final class AcronymCategoryPivot:SQLiteUUIDPivot{
    
    var id:UUID?
    
    var acronymID:Acronyms.ID
    
    var categoryID:Category.ID
    
    typealias Left = Acronyms
    typealias Right = Category
    
    static var leftIDKey: LeftIDKey = \AcronymCategoryPivot.acronymID
    static var rightIDKey: RightIDKey = \AcronymCategoryPivot.categoryID
    
    init(_ acronymID:Acronyms.ID, _ cateID:Category.ID) {
        self.acronymID = acronymID
        self.categoryID = cateID
    }
}


extension AcronymCategoryPivot: Migration{}
