import Vapor
import HTTP
import VaporPostgreSQL

final class FavoritesController {

//    func makeResource() -> Resource<Favorites> {
//        return Resource(
//            index: index,
//            store: create,
//            show: show,
//            modify: update,
//            destroy: delete
//        )
//    }

    func addRoutes(drop: Droplet) {
        let basic = drop.grouped("favorites")
        basic.get(handler: index)
        basic.post(handler: create)
        basic.get(Favorite.self, handler: show)
        basic.patch(Favorite.self, handler: update)
        basic.delete(Favorite.self, handler: delete)
        basic.get(Favorite.self, "cat", handler: catShow)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var favorites = try request.favorite()
        try favorites.save()
        return favorites
    }

    func show(request: Request, favorites: Favorite) throws -> ResponseRepresentable {
        return favorites
    }

    func update(request: Request, favorite: Favorite) throws -> ResponseRepresentable {
        let new = try request.favorite()
        var favorite = favorite
        favorite.category = new.category
        favorite.value = new.value
        try favorite.save()
        return favorite
    }

    func delete(request: Request, favorites: Favorite) throws -> ResponseRepresentable {
        try favorites.delete()
        return JSON([:])
    }

    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Favorite.all().makeJSON())
    }

    func catShow(request: Request, favorite: Favorite) throws -> ResponseRepresentable {
        let cat = try favorite.cat()
        return try JSON(node: cat?.makeNode())
    }
}

extension Request {
    func favorite() throws -> Favorite {
        guard let json = json else { throw Abort.badRequest }

        return try Favorite(node: json)
    }
}
