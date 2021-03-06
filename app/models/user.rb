# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord

    attr_reader :password
    after_initialize :ensure_session_token
    before_validation :ensure_session_token
    validates :username, :session_token, presence: true
    validates :password, length: { minimum: 6, allow_nil: true}
    validates :password_digest, presence: { message: 'Password cannot be blank'}
    

    def reset_session_token!
        self.session_token = User.generate_session_token
        return self.session_token
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
        
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil unless user
        if user.is_password?(password)
            return user
        else
            nil
        end
    end

    private
    
    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end
end
