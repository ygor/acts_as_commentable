class User < ActiveRecord::Base
  validates_presence_of :name
  acts_as_commenter
  acts_as_commentable
end
