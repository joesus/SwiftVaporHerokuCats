import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)

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

drop.run()
