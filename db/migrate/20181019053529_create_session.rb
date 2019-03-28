class CreateSession < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
        t.integer :session_id
        t.integer :story_id
    end
  end
end
