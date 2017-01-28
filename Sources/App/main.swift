import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations = [Cat.self]

let catsController = CatsController()
catsController.addRoutes(drop: drop)

drop.run()
