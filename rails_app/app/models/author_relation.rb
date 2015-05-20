class AuthorRelation < ActiveRecord::Base
  belongs_to :author
  belongs_to :related_author, :class_name => "Author", :foreign_key => "related_author_id"
end
