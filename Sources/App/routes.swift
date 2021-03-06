import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
//    router.get { req in
//        return "It works!"
//    }
//
//    // Basic "Hello, world!" example
//    router.get("hello") { req in
//        return "Hello, world!"
//    }
//
//    // Example of configuring a controller
//    let todoController = TodoController()
//    router.get("todos", use: todoController.index)
//    router.post("todos", use: todoController.create)
//    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    let controller = AcronymsController()
    try router.register(collection: controller)
    let userController = UserController()
    try router.register(collection: userController)
    let catController = CategoryController()
    try router.register(collection: catController)
    let webController = WebsiteController()
    try router.register(collection: webController)
}
