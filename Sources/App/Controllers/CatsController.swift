import Vapor
import HTTP
import VaporPostgreSQL

final class CatsController {

    func addRoutes(drop: Droplet) {
        drop.get("version", handler: version)
        drop.get("cats", handler: cats)
        drop.post("cat", handler: cat)
    }

    func version(request: Request) throws -> ResponseRepresentable {
        if let db = drop.database?.driver as? PostgreSQLDriver {
            let version = try db.raw("SELECT version()")
            return try JSON(node: version)
        } else {
            return "No db connection"
        }
    }

    func cats(request: Request) throws -> ResponseRepresentable {
        var cat = try Cat(node: request.json)
        try cat.save()
        return cat
    }

    func cat(request: Request) throws -> ResponseRepresentable {
        var cat = try Cat(node: request.json)
        try cat.save()
        return cat
    }


}
