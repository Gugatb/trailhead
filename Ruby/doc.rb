
class Doc
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :test_collection_id, type: Integer
  field :content, type: String

  index({created_at: 1}, {expire_after_seconds: 1.minutes})
  # index({created_at: 1}, { expire_after_seconds: 3600 })
  # New in version 2.2.
  # db.test_collections.ensureIndex( { "created_at": 1 }, { expireAfterSeconds: 30 } )
end
