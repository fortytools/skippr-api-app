class CreateSkipprUsers < ActiveRecord::Migration
  def self.up
    create_table :skippr_users do |t|
      t.string :key
      t.string :secret

      t.timestamps
    end
  end

  def self.down
    drop_table :skippr_users
  end
end
