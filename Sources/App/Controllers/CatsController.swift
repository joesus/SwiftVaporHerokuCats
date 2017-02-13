import Vapor
import HTTP
import VaporPostgreSQL

final class CatsController {

    func addRoutes(drop: Droplet) {
        let basic = drop.grouped("cats")
        basic.get(handler: cats)
        basic.get(Cat.self, handler: cat)
        basic.patch(Cat.self, handler: update)
        basic.post(handler: create)
        basic.delete(Cat.self, handler: delete)
        basic.get(Cat.self, "favorites", handler: favoritesIndex)
    }

    func cats(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Cat.all().makeJSON())
    }

    func cat(request: Request, cat: Cat) throws -> ResponseRepresentable {
        let favs = try cat.allFavorites()
        cat.favorites = favs
        return cat
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var cat = try request.cat()
        try cat.save()
        return cat
    }

    func update(request: Request, cat: Cat) throws -> ResponseRepresentable {
        let new = try request.cat()
        var cat = cat
        setAttributesFor(cat, with: new)
        try cat.save()
        return cat
    }

    func delete(request: Request, cat: Cat) throws -> ResponseRepresentable {
        let favs = try cat.allFavorites()
        try favs.forEach { try $0.delete() }
        try cat.delete()
        return JSON([:])
    }

    func version(request: Request) throws -> ResponseRepresentable {
        if let db = drop.database?.driver as? PostgreSQLDriver {
            let version = try db.raw("SELECT version()")
            return try JSON(node: version)
        } else {
            return "No db connection"
        }
    }

    func favoritesIndex(request: Request, cat: Cat) throws -> ResponseRepresentable {
        let children = try cat.allFavorites()
        return try JSON(node: children.makeNode())
    }

    func setAttributesFor(_ cat: Cat, with new: Cat) {
        if cat.name != new.name {
            cat.name = new.name
        }
        if cat.age != new.age {
            cat.age = new.age
        }
        if cat.city != new.city {
            cat.city = new.city
        }
        if cat.state != new.state {
            cat.state = new.state
        }
        if cat.cutenessLevel != new.cutenessLevel {
            cat.cutenessLevel = new.cutenessLevel
        }
        if cat.gender != new.gender {
            cat.gender = new.gender
        }
        if cat.adoptable != new.adoptable {
            cat.adoptable = new.adoptable
        }
        if cat.greeting != new.greeting {
            cat.greeting = new.greeting
        }
        if cat.pictureURL != new.pictureURL {
            cat.pictureURL = new.pictureURL
        }
        if cat.weight != new.weight {
            cat.weight = new.weight
        }
    }
}

extension Request {
    func cat() throws -> Cat {
        guard let json = json else { throw Abort.badRequest }

        return try Cat(node: json)
    }
}
