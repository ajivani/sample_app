require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
    @attr = { 
              :name=> "Sammy Junior Example", 
              :email=>"example@email.com",
              :password=>'foobar',
              :password_confirmation=>'foobar'
    }
    @user = User.create!(@attr.merge(:email=>'someemail@email.com', :name=>'users name'))
    @addresses_valid = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp ]
    @addresses_invalid = %w[ user@foo,com user_at_foo.org example.user@foo.]
    @ameen = User.create!(@attr.merge(:name=>'ameen', :email=>'ameensemail@email.com')) #creates a valid user
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
    @addresses_valid.each do |valid_address|
      valid_email_user = User.new(@attr.merge(:email=>valid_address))
      valid_email_user.should be_valid #like saying valid? = be_ be_empty == empty?
    end
  end
  describe 'password validations' do
    it 'should require a password' do
      User.new(@attr.merge(:password=>'',:password_confirmation=>'')).should_not be_valid
    end
    it 'should require a matching password' do
      User.new(@attr.merge(:password_confirmation=>'notmatching')).should_not be_valid
    end
    it 'should reject short passowrds ( < 5 characters) ' do
      short = 'a'*5
      User.new(@attr.merge(:password=>short, :password_confirmation=>short)).should_not be_valid
    end
    it 'should reject long passwords ( > 40 characters)' do
      long = 'a'*41
      hash = @attr.merge(:password=>long, :password_confirmation=>long )
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    it 'should have an encrypted password field' do
     @ameen.should respond_to(:encrypted_password) #true compared to the result of ((respond_to(encryted_password))
    end
    it 'should set the encrypted password' do
      @ameen.encrypted_password.should_not be_blank
    end
  end
  describe "has_password? method" do
    it "should be true if the passwords match" do
      @ameen.has_password?(@ameen.password).should be_true
    end
    it "should be true if the passwords match with just a string check" do
      @ameen.has_password?('foobar').should be_true
    end
    it "should be bobbyfalse if the passwords don't match" do 
      @ameen.has_password?('wrongpassword').should be_false
    end

    describe "authenticate method" do
      before(:each) do
          @default_user = User.create!(@attr)
      end
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email],"wrong password")
        wrong_password_user.should be_nil
      end
      it "should return nil for an email address with no user" do
        no_user = User.authenticate('noemaillikethis@email.com', @attr[:password])
        no_user.should be_nil
      end
      it "should return the user object itself if the user is correct" do
        sammy_j = User.authenticate(@attr[:email], @attr[:password])
        sammy_j.should_not be_nil
        sammy_j.should == @default_user
      end
    end

  end #has_password? 

end #user