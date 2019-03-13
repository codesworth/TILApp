

import Vapor


struct CategoryController:RouteCollection{
    
    func boot(router: Router) throws {
        let catRoute = router.grouped("api","category")
        catRoute.get(use: getAllHandler)
        catRoute.get(Category.parameter, use: getSingleHandler)
        catRoute.post(Category.self, use: createHandler)
        catRoute.put(Category.parameter, use: update)
        catRoute.delete(Category.parameter, use: delete)
    }
    
    
    func getAllHandler(_ req:Request)throws -> Future<[Category]>{
        
        return Category.query(on: req).all()
    }
    
    func getSingleHandler(_ req:Request) throws -> Future<Category>{
        
        return try req.parameters.next(Category.self)
    }
    
    func createHandler(_ req:Request,category:Category)throws -> Future<Category>{
        return category.save(on: req)
    }
    
    func delete(_ req:Request) throws -> Future<HTTPStatus>{
        return try req.parameters.next(Category.self).flatMap(to: HTTPStatus.self) {
            $0.delete(on: req).transform(to: .noContent)
        }
    }
    
    func update(_ req: Request) throws -> Future<Category>{
        
        return try flatMap(to: Category.self, req.parameters.next(Category.self), req.content.decode(Category.self), { oldcat, newcat in
            oldcat.name = newcat.name
            return oldcat.save(on: req)
        })
    }
}
