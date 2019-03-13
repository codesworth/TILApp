
import Vapor


struct UserController:RouteCollection{
    
    func boot(router: Router) throws {
        let userRoutes = router.grouped("api","user")
        userRoutes.get(use: getAllUsers)
        userRoutes.post(User.self, use: createHandler)
        userRoutes.get(User.parameter, use: getSingle)
        userRoutes.put(User.parameter, use: updateHandler)
        userRoutes.delete(User.parameter, use: delete)
    }
    
    func getAllUsers(_ req:Request)throws ->Future<[User]>{
        return User.query(on: req).all()
    }
    
    func createHandler(_ req:Request, user:User)throws -> Future<User> {
        return  user.save(on: req)
    }
    
    func getSingle(_ req:Request)throws -> Future<User>{
        return try req.parameters.next(User.self)
    }
    
    func delete(_ req:Request) throws -> Future<HTTPStatus>{
        return try req.parameters.next(User.self).flatMap(to: HTTPStatus.self){
            $0.delete(on: req).transform(to: .noContent)
        }
    }
    
    func updateHandler(_ req:Request) throws -> Future<User>{
        return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self), { olduser, updatedUser in
            olduser.name = updatedUser.name
            olduser.username = updatedUser.username
            return olduser.save(on: req)
        })
    }
}
