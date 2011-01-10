class CreateUserSessions < ActiveRecord::Migration
  def self.up
    create_table :user_sessions do |t|
      t.string :identifier
      t.string :access_token
      t.string :access_secret

      t.timestamps
    end
  end

  def self.down
    drop_table :user_sessions
  end
end
