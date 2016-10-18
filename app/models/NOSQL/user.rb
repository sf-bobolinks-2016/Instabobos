class User 
	include Mongoid::Document
  # Remember to create a migration!

  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
end


 