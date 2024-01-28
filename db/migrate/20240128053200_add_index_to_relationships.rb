# frozen_string_literal: true

class AddIndexToRelationships < ActiveRecord::Migration[7.0]
  def change
    add_index :relationships, %i[following_id follower_id], unique: true
  end
end
