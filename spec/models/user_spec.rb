require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
    @attr = {:name=> "Example User", :email=>"example@email.com"}
    @addresses_valid = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp ]
    @addresses_invalid = %w[ user@foo,com user_at_foo.org example.user@foo.]
  end  
  it "should create a new instance given valid attribues" do
    User.create! (@attr)
    # user = User.new(@attr)
    #user.save
    #assert_equal true, user.errors.empty?
  end
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name=>""))
    no_name_user.should_not be_valid
    #no_name_user.valid?.should_not == true
  end
  it "name should be less than 50 characters" do 
    long_name =  "a" * 51 
    samuuuuuuuuuuuuuuuuual = User.new(@attr.merge(:name=>long_name))
    samuuuuuuuuuuuuuuuuual.should_not be_valid
  end
  it "should require a non blank email" do
    ameen = User.new(@attr.merge(:email=>""))
    ameen.should_not be_valid
  end
  it "should accept all forms of valid email address" do
    @addresses_valid.each do |some_email_address|
      valid_email_user = User.new(@attr.merge(:email=>some_email_address))
      valid_email_user.should be_valid #like saying valid? = be_ be_empty == empty?
    end
  end
  it "should not accept invalid email addresses" do
    @addresses_invalid.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  it "should reject duplicate email addresses" do
    #Put user with given email address in the db
    User.create!(@attr)
    bob_jones = User.new(@attr)
    bob_jones.should_not be_valid
  end
  it "should reject an email address identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr)
    sammey_emails = User.new(@attr.merge(:email=>upcased_email))
    sammey_emails.should_not be_valid
  end

end
