require 'data_mapper'
require 'bcrypt'

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :password_digest, Text

  def password=(password) #attr_writer-ish
    self.password_digest = BCrypt::Password.create(password) #capital C!!!
  end
end