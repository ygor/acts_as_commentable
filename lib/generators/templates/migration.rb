class ActsAsCommentableMigration < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.references :commentable, :polymorphic => true, :null => false
      t.references :commenter, :polymorphic => true, :null => false
      t.text :body, :null => false
      t.boolean :private, :default => false
      t.boolean :read, :default => false
      t.string :ancestry
      t.timestamps
    end

    add_index :comments, ["commenter_id", "commenter_type"], :name => "fk_commenters"
    add_index :comments, ["commentable_id", "commentable_type"], :name => "fk_commentables"
    add_index :comments, :ancestry
  end

  def self.down
    drop_table :comments
  end
end
