module ActsAsCommentable #:nodoc:
  module Commentable

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_commentable
        has_many :comments, :as => :commentable, :dependent => :destroy, :class_name => 'Comment'
        include ActsAsCommentable::Commentable::InstanceMethods
      end
    end

    module InstanceMethods
      def threads
        self.comments.roots.descending
      end
      
      def commented_by?(commenter)
        self.comments.for_commenter(commenter).size > 0
      end
      
      def comments_count
        self.comments.count
      end
      
      def threads_count
        self.comments.roots.count
      end
    end
  end
end