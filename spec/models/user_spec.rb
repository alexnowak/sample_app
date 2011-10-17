require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
        :name => "Example User",
        :email => "user@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
    }
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should accept valid names" do
    names = ["Alex Nowak", "ALEX NOWAK", "Alex$Nowak", "!\@\#\#\@#\%\@\#", "asd", "a" * 50]
    names.each do |name|
      # puts "Testing VALID User name: "+name
      valid_name = User.new(@attr.merge(:name => name))
      valid_name.should be_valid
    end
  end

  it "should reject invalid names" do
    names = ["", "ab", "a"*51]
    names.each do |name|
      # puts "Testing INVALID User name: "+name
      invalid_name = User.new(@attr.merge(:name => name))
      invalid_name.should_not be_valid
    end
  end

  it "should accept valid email addresses" do
    addresses = ["user@foo.com",
                 "THE_USER@foo.bar.org",
                 "first.last@foo.jp",
                 "first_last@foo.jp",
                 "huhu.hu.hu.hu@bla.bla.bla.bla.com"]
    addresses.each do |address|
      # puts "Testing VALID email: "+address
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = ["user@foo,com",
                 "user_at_foo.org",
                 "example.user@foo.",
                 "some user@booboo.org",
                 "some@user@someorg.org",
                  "abcd!def$@bobo.org","newline\n@hustekuchen.com"]
    addresses.each do |address|
      # puts "Testing INVALID email: " + address
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end


    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end



  describe "Password validation" do

      before(:each) do
        @user = User.create!(@attr)
      end

      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
      end

      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
      end

      it "should reject short passwords" do
        short = "a" * 5
        hash = @attr.merge(:password => short, :password_confirmation => short)
        User.new(hash).should_not be_valid
      end

      it "should reject long passwords" do
        long = "a" * 41
        hash = @attr.merge(:password => long, :password_confirmation => long)
        User.new(hash).should_not be_valid
        end

      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end

      it "should set the encrypted password" do
        @user.encrypted_password.should_not be_blank
      end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
      end
    end
  end
end
