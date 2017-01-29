import Vapor

struct CatTableKeys {
    static let tableName = "cats"
    static let id = "id"
    static let name = "name"
    static let adoptable = "adoptable"
    static let age = "age"
    static let city = "city"
    static let state = "state"
    static let cutenessLevel = "cutenessLevel"
    static let gender = "gender"
    static let greeting = "greeting"
    static let pictureURL = "pictureURL"
    static let weight = "weight"
}

final class Cat: Model {

    var id: Node?
    var exists: Bool = false

    var name: String?
    var adoptable: Bool
    var age: Int? = 0
    var city: String?
    var state: String?
    var cutenessLevel: Int?

    init(name: String? = "", adoptable: Bool = false, age: Int?, city: String?, state: String?, cutenessLevel: Int?) {
        self.id = nil
        self.name = name
        self.adoptable = adoptable
        self.age = age
        self.city = city
        self.state = state
        if let cutenessLevel = cutenessLevel {
            self.cutenessLevel = cutenessLevel
        }
    }

    init(node: Node, in context: Context) throws {
        self.id = try node.extract(CatTableKeys.id)
        self.name = try node.extract(CatTableKeys.name)
        self.adoptable = try node.extract(CatTableKeys.adoptable) ?? false
        self.age = try node.extract(CatTableKeys.age)
        self.city = try node.extract(CatTableKeys.city)
        self.state = try node.extract(CatTableKeys.state)
        self.cutenessLevel = try node.extract(CatTableKeys.cutenessLevel)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            CatTableKeys.id: id,
            CatTableKeys.name: name,
            CatTableKeys.adoptable: adoptable,
            CatTableKeys.age: age,
            CatTableKeys.city: city,
            CatTableKeys.state: state,
            CatTableKeys.cutenessLevel: cutenessLevel,
        ])
    }
}

//MARK: - Database Setup
extension Cat {
    static func prepare(_ database: Database) throws {
        try database.create(CatTableKeys.tableName) { cats in
            cats.id()
            cats.string(CatTableKeys.name)
            cats.bool(CatTableKeys.adoptable, optional: true)
            cats.int(CatTableKeys.age, optional: true)
            cats.string(CatTableKeys.city, optional: true)
            cats.string(CatTableKeys.state, optional: true)
            cats.int(CatTableKeys.cutenessLevel, optional: true)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(CatTableKeys.tableName)
    }
}

extension Cat {
    func favorites() throws -> [Favorite] {
        return try children(nil, Favorite.self).all()
    }
}
