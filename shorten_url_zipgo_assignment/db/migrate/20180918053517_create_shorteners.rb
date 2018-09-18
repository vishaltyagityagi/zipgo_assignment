class CreateShorteners < ActiveRecord::Migration[5.1]
  def change
    create_table :shorteners do |t|
      t.string :url
      t.string :shorten_url
      t.string :sanitized_url

      t.timestamps
    end
  end
end