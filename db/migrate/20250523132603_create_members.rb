class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :name
      t.string :surname
      t.string :email_address
      t.date :birthday
      t.integer :no_of_games_played
      t.integer :current_rank

      t.timestamps
    end
  end
end
