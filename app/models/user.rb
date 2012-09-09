class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  def self.randam_string
    a = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    Array.new(16) do
      a[rand(a.size)]
    end.join
  end
end
