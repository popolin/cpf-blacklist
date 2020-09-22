class CreateBlackList < ActiveRecord::Migration[6.0]
  def change
    create_table :black_lists do |t|
      t.string :cpf, limit: 11
    end
  end
end
