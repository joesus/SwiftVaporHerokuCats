import Vapor

struct CatTableKeys {
    static let tableName = "cats"
    static let id = "id"
    static let name = "name"
    static let pictureURL = "pictureurl"
    static let about = "about"
    static let adoptable = "adoptable"
    static let age = "age"
    static let city = "city"
    static let state = "state"
    static let cutenessLevel = "cutenesslevel"
    static let gender = "gender"
    static let greeting = "greeting"
    static let weight = "weight"
    static let favorites = "favorites"
}

final class Cat: Model {

    var id: Node?
    var exists: Bool = false

    var name: String?
    var about: String?
    var pictureURL: String?
    var adoptable: Bool
    var age: Int? = 0
    var city: String?
    var state: String?
    var cutenessLevel: Int?
    var gender: String?
    var greeting: String?
    var weight: Int?
    var favorites = [Favorite]()

    init(name: String? = "", about: String?, adoptable: Bool = false, age: Int?, city: String?, state: String?,
         cutenessLevel: Int?, gender: String?, greeting: String?, pictureURL: String?, weight: Int?) {
        self.id = nil
        self.name = name
        self.pictureURL = pictureURL
        self.about = about
        self.adoptable = adoptable
        self.age = age
        self.city = city
        self.state = state
        if let cutenessLevel = cutenessLevel {
            self.cutenessLevel = cutenessLevel
        }
        self.gender = gender
        self.greeting = greeting
        self.weight = weight
    }

    init(node: Node, in context: Context) throws {
        self.id = try node.extract(CatTableKeys.id)
        self.name = try node.extract(CatTableKeys.name)
        self.pictureURL = try! node.extract(CatTableKeys.pictureURL)
        self.about = try node.extract(CatTableKeys.about)
        self.adoptable = try node.extract(CatTableKeys.adoptable) ?? false
        self.age = try node.extract(CatTableKeys.age)
        self.city = try node.extract(CatTableKeys.city)
        self.state = try node.extract(CatTableKeys.state)
        self.cutenessLevel = try node.extract(CatTableKeys.cutenessLevel)
        self.gender = try node.extract(CatTableKeys.gender)
        self.greeting = try node.extract(CatTableKeys.greeting)
        self.weight = try node.extract(CatTableKeys.weight)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            CatTableKeys.id: id,
            CatTableKeys.name: name,
            CatTableKeys.pictureURL: pictureURL,
            CatTableKeys.about: about,
            CatTableKeys.adoptable: adoptable,
            CatTableKeys.age: age,
            CatTableKeys.city: city,
            CatTableKeys.state: state,
            CatTableKeys.cutenessLevel: cutenessLevel,
            CatTableKeys.gender: gender,
            CatTableKeys.weight: weight,
            CatTableKeys.greeting: greeting
        ])
    }

    func makeAllCatsJSON() throws -> JSON {
        if let favs = try? favorites.makeJSON() {
            return try JSON(node: [
                CatTableKeys.id: id,
                CatTableKeys.name: name,
                CatTableKeys.pictureURL: pictureURL,
                CatTableKeys.about: about,
                CatTableKeys.adoptable: adoptable,
                CatTableKeys.age: age,
                CatTableKeys.city: city,
                CatTableKeys.state: state,
                CatTableKeys.cutenessLevel: cutenessLevel,
                CatTableKeys.gender: gender,
                CatTableKeys.greeting: greeting,
                CatTableKeys.weight: weight,
                CatTableKeys.favorites: favs
            ])
        } else {
            return try JSON(node: [
                CatTableKeys.id: id,
                CatTableKeys.name: name,
                CatTableKeys.pictureURL: pictureURL,
                CatTableKeys.about: about,
                CatTableKeys.adoptable: adoptable,
                CatTableKeys.age: age,
                CatTableKeys.city: city,
                CatTableKeys.state: state,
                CatTableKeys.cutenessLevel: cutenessLevel,
                CatTableKeys.gender: gender,
                CatTableKeys.greeting: greeting,
                CatTableKeys.weight: weight,
                CatTableKeys.favorites: favorites.makeJSON()
            ])
        }
    }

    func makeJSON() throws -> JSON {
        return try JSON(node: [
            CatTableKeys.id: id,
            CatTableKeys.name: name,
            CatTableKeys.pictureURL: pictureURL,
            CatTableKeys.about: about,
            CatTableKeys.adoptable: adoptable,
            CatTableKeys.age: age,
            CatTableKeys.city: city,
            CatTableKeys.state: state,
            CatTableKeys.cutenessLevel: cutenessLevel,
            CatTableKeys.gender: gender,
            CatTableKeys.greeting: greeting,
            CatTableKeys.weight: weight,
            CatTableKeys.favorites: favorites.makeJSON()
        ])
    }
}

//MARK: - Database Setup
extension Cat {
    static func prepare(_ database: Database) throws {
        try database.create(CatTableKeys.tableName) { cats in
            cats.id()
            cats.string(CatTableKeys.name)
            cats.string(CatTableKeys.pictureURL)
            cats.string(CatTableKeys.about, optional: true)
            cats.bool(CatTableKeys.adoptable, optional: true)
            cats.int(CatTableKeys.age, optional: true)
            cats.string(CatTableKeys.city, optional: true)
            cats.string(CatTableKeys.state, optional: true)
            cats.int(CatTableKeys.cutenessLevel, optional: true)
            cats.string(CatTableKeys.gender, optional: true)
            cats.string(CatTableKeys.greeting, optional: true)
            cats.int(CatTableKeys.weight, optional: true)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(CatTableKeys.tableName)
    }
}

extension Cat {
    func allFavorites() throws -> [Favorite] {
        return try children(nil, Favorite.self).all()
    }
}
