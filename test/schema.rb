ActiveRecord::Schema.define :version => 0 do

  create_table :comments, :force => true do |t|
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.integer  "commenter_id",     :null => false
    t.string   "commenter_type",   :null => false
    t.text "body", :null => false
    t.boolean "private", :default => false
    t.boolean "read", :default => false
    t.string "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table :users, :force => true do |t|
    t.column :name, :string
  end

  create_table :bands, :force => true do |t|
    t.column :name, :string
  end

end
