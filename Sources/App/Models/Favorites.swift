import Vapor

struct FavoriteKeys {
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
        id = try node.extract(FavoriteKeys.id)
        category = try node.extract(FavoriteKeys.category)
        value = try node.extract(FavoriteKeys.value)
        catId = try node.extract(FavoriteKeys.catId)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            FavoriteKeys.id: id,
            FavoriteKeys.category: category,
            FavoriteKeys.value: value,
            FavoriteKeys.catId: catId
        ])
    }
}

//MARK: - Database Setup
extension Favorite {
    static func prepare(_ database: Database) throws {
        try database.create(FavoriteKeys.tableName) { favorites in
            favorites.id()
            favorites.string(FavoriteKeys.category)
            favorites.string(FavoriteKeys.value)
            favorites.parent(Cat.self, optional: false)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(FavoriteKeys.tableName)
    }
}

extension Favorite {
    func cat() throws -> Cat? {
        return try parent(catId, nil, Cat.self).get()
    }
}
