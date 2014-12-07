class Tag
  include Neo4j::ActiveNode
  property :name, type: String
  property :tags

  has_many :out, :parent, type: :direct_to, model_class: self
  has_many :in, :items, type: :direct_to, model_class: self
end
