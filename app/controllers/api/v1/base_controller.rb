class Api::V1::BaseController < ApplicationController
  include JsonWebToken
  before_action :authenticate_user, :authorize_admin_user!

  private

  def authenticate_user
    render_error('You are not authorized to perform this action. Please signin!', :unauthorized) unless current_user.present?
  end

  def current_user
    @current_user ||= AdminUser.find_by(id: jwt_decode(token)['user_id'], jti: jwt_decode(token)['jti'])
  end

  def token
    @token ||= request.headers['Authorization']&.split(' ')&.last
  end

  def render_error message, status
    render json: { error: message }, status: status
  end

  def render_message message, status
    render json: { message: message }, status: status
  end

  def render_resource resource, serializer, status, collection = false
    if collection
      render json: resource, root: 'data', adapter: :json, each_serializer: serializer,  status: status
    else
      render json: resource, root: 'data', adapter: :json, serializer: serializer, status: status
    end
  end

  def render_access_token user_id, status
    user = AdminUser.find_by(id: user_id)
    user.revoke_jwt
    access_token = jwt_encode({ user_id: user_id, jti: user.jti })
    render json: { access_token: access_token }, status: status
  end

  def authorize_admin_user!
    unless current_user.is_a?(AdminUser)
      render_error('You are not authorized to perform this action. Please signin! As SUPER ADMIN', :unauthorized)
    end
  end
end