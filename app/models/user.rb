require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :username, :firstname, :lastname, :email, :password, :password_confirmation

  # Allow only letters, numbers, underscore for usernames
  # Perl example: my $valid = $test =~ /^\w+$/;
  #!~ test for *non* matching chars. You should also add ^ and $ bounds otherwise &&&a would still match
  # as it contains a word character. If you need to include white space in your
  # endtest you will want something more like this: /^\w+|\s+$/.
  username_regex = /^\w+$/;
  validates :username, :presence => true,
            :format => { :with => username_regex },
            :length => { :within => 3..50 },
            :uniqueness => { :case_sensitive => false }

  validates :firstname, :presence => true,
            :length => { :within => 3..50 }

  validates :lastname, :presence => true,
            :length => { :within => 3..50 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
            :format => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }

  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence => true,
            :confirmation => true,
            :length => { :within => 6..40 }

  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
	  encrypted_password == encrypt(submitted_password)
  end

  # @param email [String]
  # @param submitted_password [String]
  def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
  end

  
  private

  def encrypt_password
    self.salt = make_salt if new_record?
	self.encrypted_password = encrypt(password)
  end

  # @param string [String]
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
	secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
	Digest::SHA2.hexdigest(string)
  end
end