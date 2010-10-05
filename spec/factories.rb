#by using the symbol ':user' we get Facgory Girl to simulate the User model
Factory.define :user do |user|
  user.name                   "Ameen Jivani"
  user.email                  "ameenjivani@email.co.uk"
  user.password               "password"
  user.password_confirmation  "password"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |mpost|
  mpost.content  "today i saw a bird it was awesome, i'm gonna tweet this information"
  mpost.association :user
end
