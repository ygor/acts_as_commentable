require File.dirname(__FILE__) + '/acts_as_commentable/base'
require File.dirname(__FILE__) + '/acts_as_commentable/commentable'
require File.dirname(__FILE__) + '/acts_as_commentable/commenter'

require 'active_record'
require 'ancestry'

ActiveRecord::Base.send(:include, ActsAsCommentable::Commentable)
ActiveRecord::Base.send(:include, ActsAsCommentable::Commenter)