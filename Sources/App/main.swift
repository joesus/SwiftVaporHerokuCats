import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations += Cat.self
drop.preparations += Favorite.self

CatsController().addRoutes(drop: drop)
FavoritesController().addRoutes(drop: drop)

drop.run()
