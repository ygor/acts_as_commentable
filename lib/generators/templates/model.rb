class Comment < ActiveRecord::Base
  extend ActsAsCommentable::Base

  scope :public, lambda { where('private = 0') }
  scope :private, lambda { where('private = 1') }
  scope :for_commenter, lambda { |commenter| where(["commenter_id = ? AND commenter_type = ?", commenter.id, parent_class_name(commenter)]) }
  scope :for_commentable, lambda { |commentable| where(["commentable_id = ? AND commentable_type = ?", commentable.id, parent_class_name(commentable)]) }
  scope :recent, lambda { |from| where(["created_at > ?", (from || 2.weeks.ago).to_s(:db)]) }
  scope :descending, order("comments.created_at DESC")
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :commenter, :polymorphic => true
  
  has_ancestry
  
  validates_presence_of :body
  validates_presence_of :commentable
  validate :private_conversation
  
  def reply(commenter, body)
    children.create(:commenter => commenter, :commentable => commentable, :body => body, :private => private?)
  end
  
  protected
  
  def private_conversation
    self.class.unscoped do
      errors.add(:private, "This thread is private.") if private? && !is_root? && parent.commenter != commenter
    end
  end
end