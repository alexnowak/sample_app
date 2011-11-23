class UserChanges < ActiveRecord::Migration
  def change

	change_table :users do |t|
	  	t.string :firstname
		t.string :lastname
  		t.index :firstname
		t.index :lastname
		t.rename :name, :username
	    t.index :username
	end

  end
end
