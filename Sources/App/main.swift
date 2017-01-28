import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations = [Cat.self]

drop.resource("cats", CatsController())

drop.run()
