class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
      # これは、created_atとupdated_atという2つのカラムを追加するメソッドです。
    end
  end
end
