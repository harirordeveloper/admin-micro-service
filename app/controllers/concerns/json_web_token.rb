require 'jwt'

module JsonWebToken
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secret_key_base

  def jwt_encode(payload, exp: 1.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode token
    @decoded_jwt ||= JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' }).first
  rescue
    {}
  end
end