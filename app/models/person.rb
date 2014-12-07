class Person 
  include Neo4j::ActiveNode
  property :name, type: String
  property :born, type: Integer
end
