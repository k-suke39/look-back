# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :following_id
      t.integer :follower_id

      t.timestamps
    end
  end
end
