#by using the symbol ':user' we get Facgory Girl to simulate the User model
Factory.define :user do |user|
  user.name                   "Ameen Jivani"
  user.email                  "ameenjivani@email.co.uk"
  user.password               "password"
  user.password_confirmation  "password"
end
