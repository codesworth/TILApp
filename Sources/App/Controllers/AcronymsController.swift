
import Vapor

struct AcronymsController:RouteCollection{
    
    func boot(router: Router) throws {
        let acronymsRoute = router.grouped("api","acronyms")
        acronymsRoute.get(use: getAllhandler)
        acronymsRoute.post(Acronyms.self, use: createHandler)
        acronymsRoute.get(Acronyms.parameter, use: getAcronymHandler)
        acronymsRoute.delete(Acronyms.parameter, use: deleteHandler)
        acronymsRoute.put(Acronyms.parameter, use: updateAcronym)
        acronymsRoute.get(Acronyms.parameter,"user", use: getUserHandler)
        acronymsRoute.get(Acronyms.parameter,"categories", use: getCategories)
        acronymsRoute.post(Acronyms.parameter,"categories",Category.parameter, use: addCategoriesHandler)
    }
    
    func getUserHandler(_ req:Request) throws -> Future<User>{
        return try req.parameters.next(Acronyms.self).flatMap(to: User.self){
            $0.user.get(on: req)
        }
    }
    
    func getAcronymHandler(_ req: Request) throws ->Future<Acronyms>{
        return try req.parameters.next(Acronyms.self)
    }
    
    func getAllhandler(_ req:Request)throws -> Future<[Acronyms]>{
        return Acronyms.query(on: req).all()
    }
    
    func createHandler(_ req:Request, acronym:Acronyms) throws -> Future<Acronyms>{
        return acronym.save(on: req)
    }
    
    func deleteHandler(_ req:Request)throws -> Future<HTTPStatus>{
        return try req.parameters.next(Acronyms.self).flatMap(to: HTTPStatus.self){
            $0.delete(on: req).transform(to: .noContent)
        }
    }
    
    func updateAcronym(_ req:Request) throws -> Future<Acronyms>{
        return try flatMap(to: Acronyms.self, req.parameters.next(Acronyms.self), req.content.decode(Acronyms.self), { (acronym, updatedAcronym) in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            return acronym.save(on: req)
        })
    }
    
    func getCategories(_ req:Request) throws -> Future<[Category]>{
        return try req.parameters.next(Acronyms.self).flatMap(to: [Category].self){
            try $0.categories.query(on: req).all()
        }
    }
    
    func addCategoriesHandler(_ req:Request)throws -> Future<HTTPStatus>{
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Acronyms.self), req.parameters.next(Category.self)){ acr, cat in
            let pivot = try AcronymCategoryPivot(acr.requireID(), cat.requireID())
            return pivot.save(on: req).transform(to: .ok)
        }
    }
}
