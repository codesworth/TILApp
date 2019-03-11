
import Vapor

struct AcronymsController:RouteCollection{
    
    func boot(router: Router) throws {
        let acronymsRoute = router.grouped("api","acronyms")
        acronymsRoute.get(use: getAllhandler)
        acronymsRoute.post(Acronyms.self, use: createHandler)
        
    }
    
    func getAllhandler(_ req:Request)throws -> Future<[Acronyms]>{
        return Acronyms.query(on: req).all()
    }
    
    func createHandler(_ req:Request, acronym:Acronyms) throws -> Future<Acronyms>{
        return acronym.save(on: req)
    }
}
