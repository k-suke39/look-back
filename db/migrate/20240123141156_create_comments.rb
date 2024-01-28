# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :content, null: false
      t.references :user, foreign_key: true, null: false
      t.references :scrap, foreign_key: true, null: false
      t.timestamps
    end
  end
end
