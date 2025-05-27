class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.integer :player_one_id
      t.integer :player_two_id
      t.integer :result

      t.timestamps
    end
  end
end
