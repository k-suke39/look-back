# frozen_string_literal: true

class CreateTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|
      t.references :scrap, foreign_key: true
      t.references :tag, foreign_key: true
      t.timestamps
    end
    add_index :taggings, %i[tag_id scrap_id], unique: true
  end
end
