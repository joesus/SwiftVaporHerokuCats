import Vapor

struct FavoritesKeys {
    static var tableName = "favorites"
    static var id = "id"
    static var catId = "cat_id"
    static var category = "category"
    static var value = "value"
}

final class Favorite: Model {

    var id: Node?
    var exists: Bool = false

    var category: String?
    var value: String?
    var catId: Node?

    init(category: String?, value: String?, catId: Node? = nil) {
        self.id = nil
        self.category = category
        self.value = value
        self.catId = catId
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract(FavoritesKeys.id)
        category = try node.extract(FavoritesKeys.category)
        value = try node.extract(FavoritesKeys.value)
        catId = try node.extract(FavoritesKeys.catId)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            FavoritesKeys.id: id,
            FavoritesKeys.category: category,
            FavoritesKeys.value: value,
            FavoritesKeys.catId: catId
        ])
    }
}

//MARK: - Database Setup
extension Favorite {
    static func prepare(_ database: Database) throws {
        try database.create(FavoritesKeys.tableName) { favorites in
            favorites.id()
            favorites.string(FavoritesKeys.category)
            favorites.string(FavoritesKeys.value)
            favorites.parent(Cat.self, optional: false)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(FavoritesKeys.tableName)
    }
}

extension Favorite {
    func cat() throws -> Cat? {
        return try parent(catId, nil, Cat.self).get()
    }
}
