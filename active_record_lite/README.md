#Active Record Lite

ActiveRecord Lite is an ORM inspired by the functionality of Rails' ActiveRecord.  It utilizes metaprogramming to create methods that allows Ruby to interact with a SQLite3 database.

###Available Methods:

##### SQLObject
- `#save`
- `#create`
- `#update`
- `#destroy`
- `#find(id)`
- `#where(params)`
- `#all`

##### Associatable (module extended by SQLObject)
- `belongs_to`
- `has_many`
- `has_one_through`
