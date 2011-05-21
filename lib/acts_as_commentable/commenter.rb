module ActsAsCommentable #:nodoc:
  module Commenter

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_commenter
        has_many :commentings, :as => :commenter, :dependent => :destroy, :class_name => 'Comment'
        include ActsAsCommentable::Commenter::InstanceMethods
      end
    end

    module InstanceMethods
      
      def commented?(commentable)
        self.commentings.for_commentable(commentable).size > 0
      end
      
      def comment(commentable, body, priv = false, parent = nil)
        self.commentings.create(:commentable => commentable, :body => body, :private => priv, :parent => parent)
      end
    end
  end
end