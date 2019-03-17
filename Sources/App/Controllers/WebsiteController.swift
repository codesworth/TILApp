import Vapor


struct WebsiteController:RouteCollection {
    
    typealias WebView = Future<View>
    
    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.get("acronyms",Acronyms.parameter, use: acronymsHnadler)
        router.get("users", User.parameter,use:userHandler)
    }
    
    func indexHandler(_ req:Request) throws -> Future<View>{
        return Acronyms.query(on: req).all().flatMap(to: View.self){ acronyms in
            let context = IndexContext(title: "HomePage", acronyms: acronyms)
            return try req.view().render("index",context)
        }
        
        
        
    }
    
    func acronymsHnadler(_ req:Request)throws ->Future<View>{
        return try req.parameters.next(Acronyms.self).flatMap(to: View.self){ acronym in
            return acronym.user.get(on: req).flatMap(to: View.self){ user in
               let context = AcronymContext(title: acronym.long, Acronym: acronym, user: user)
                return try req.view().render("acronym", context)
            }
        }
    }
    
    func userHandler(_ req:Request)throws ->WebView{
        return try req.parameters.next(User.self).flatMap(to: View.self){ user in
            let ctx = UserContxt(title: user.name, user: user, acronyms: try user.acronyms.query(on: req).all())
            return try req.view().render("user", ctx)
        }
    }
}



struct IndexContext:Encodable{
    let title:String
    let acronyms:[Acronyms]?
}


struct AcronymContext:Encodable {
    
    let title:String
    let Acronym:Acronyms
    let user:User
}

struct UserContxt:Encodable{
    
    let title:String
    let user:User
    let acronyms:Future<[Acronyms]>
}
