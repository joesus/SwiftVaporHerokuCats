import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations = [Cat.self]

drop.get("version") { request in
    print("why not work?")
    if let db = drop.database?.driver as? PostgreSQLDriver {
        print("is there driver?")
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return "Driver did not initialize"
    }

}

drop.get("cats") { request in
    return try JSON(node: Cat.all().makeNode())
}

drop.get("test") { request in
    var cat = Cat(name: "First", adoptable: true, age: 1, city: "Denver", state: "CO", cutenessLevel: 4)
    try cat.save()
    return try JSON(node: Cat.all().makeNode())
}

drop.run()
