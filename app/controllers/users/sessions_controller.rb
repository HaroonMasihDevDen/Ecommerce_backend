
class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user_custom, only: [:validate_token]
  respond_to :json

  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end
  def respond_to_on_destroy
    if request.headers['Authorization'].present? && request.headers['Authorization'].to_s != 'undefined'
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    else
      p "Authorization token is missing or invalid"
    end

    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

  def validate_token
    # Token is validated by the `authenticate_user!` method
    render json: { valid: true }, status: :ok
  end

  def authenticate_user_custom
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
        @current_user = User.find(jwt_payload['sub'])
        render json: { valid: true }, status: :ok
      rescue JWT::DecodeError => e
        render json: { valid: false, errors: [e.message] }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { valid: false, errors: ['User not found'] }, status: :unauthorized
      end
    else
      render json: { valid: false, errors: ['Token missing'] }, status: :unauthorized
    end
  end
end



# #{ this is good one for login and also give token after login but logout is not working}
# # class Users::SessionsController < Devise::SessionsController
# #   respond_to :json

# #   def create
# #     resource = warden.authenticate!(auth_options)
# #     if resource
# #       token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
# #       render json: {
# #         status: { code: 200, message: 'Logged in successfully.' },
# #         data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] },
# #         token: token
# #       }, status: :ok
# #     else
# #       render json: { errors: ['Invalid email or password'] }, status: :unprocessable_entity
# #     end
# #   end

# #   def destroy
# #     if current_user
# #       Warden::JWTAuth::TokenRevoker.new.call(request.env['warden-jwt_auth.token'])
# #       render json: { message: 'Logged out successfully.' }, status: :ok
# #     else
# #       render json: { errors: ['Not logged in'] }, status: :unauthorized
# #     end
# #   end

# #   private

# #   def respond_with(resource, _opts = {})
# #     render json: {
# #       status: { code: 200, message: 'Logged in successfully.' },
# #       data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
# #     }, status: :ok
# #   end

# #   def respond_to_on_destroy
# #     if current_user
# #       render json: {
# #         status: 200,
# #         message: 'Logged out successfully.'
# #       }, status: :ok
# #     else
# #       render json: {
# #         status: 401,
# #         message: "Couldn't find an active session."
# #       }, status: :unauthorized
# #     end
# #   end
# # end

# class Users::SessionsController < Devise::SessionsController
#   respond_to :json

#   def create
#     resource = warden.authenticate!(auth_options)
#     p "below is the resources"
#     p resource
#     p "above is the resources"
#     if resource && resource.persisted?

#       token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
#       response.set_header('auth', "#{token}")
#       # response.set_header('authorization', "#{token}")
#       render json: {
#         status: { code: 200, message: 'Logged in successfully.' },
#         data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] },
#         token: token
#       }, status: :ok
#     else
#       render json: { errors: ['Invalid email or password'] }, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     token = request.headers['auth']&.split(' ')&.last
#     # token = request.headers['Content-Length']
#     p "this is my token: #{token}"
#     # x_frame_options = request.headers['x-frame-options']
#     # p "hello world"
#     # token='asd'
#     if token
#       begin
#         jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
#         current_user = User.find(jwt_payload['sub'])
#         Warden::JWTAuth::TokenRevoker.new.call(token)
#         render json: { message: 'Logged out successfully.' }, status: :ok
#       rescue JWT::DecodeError => e
#         render json: { errors: [e.message] }, status: :unprocessable_entity
#       end
#     else
#       render json: { errors: ['Missing token'] }, status: :unprocessable_entity
#     end
#   end

#   private

#   def respond_with(resource, _opts = {})
#     render json: {
#       status: { code: 200, message: 'Logged in successfully.' },
#       data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
#     }, status: :ok
#   end

#   def respond_to_on_destroy
#     if current_user
#       render json: {
#         status: 200,
#         message: 'Logged out successfully.'
#       }, status: :ok
#     else
#       render json: {
#         status: 401,
#         message: "Couldn't find an active session."
#       }, status: :unauthorized
#     end
#   end
# end



# class Users::SessionsController < Devise::SessionsController
#   respond_to :json

#   def create
#     resource = warden.authenticate!(auth_options)
#     if resource
#       token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
#       response.set_header('Authorization', "Bearer #{token}")
#       render json: {
#         status: { code: 200, message: 'Logged in successfully.' },
#         data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] },
#         token: token
#       }, status: :ok
#     else
#       render json: { errors: ['Invalid email or password'] }, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     token = request.headers['Authorization']&.split(' ')&.last
#     if token
#       begin
#         jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
#         current_user = User.find(jwt_payload['sub'])
#         p token

#         Warden::JWTAuth::TokenRevoker.new.call(token)
#         render json: { message: 'Logged out successfully.' }, status: :ok
#       rescue JWT::DecodeError => e
#         render json: { errors: [e.message] }, status: :unprocessable_entity
#       end
#     else
#       render json: { errors: ['Missing token'] }, status: :unprocessable_entity
#     end
#   end

#   private

#   def respond_with(resource, _opts = {})
#     render json: {
#       status: { code: 200, message: 'Logged in successfully.' },
#       data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
#     }, status: :ok
#   end

#   def respond_to_on_destroy
#     if current_user
#       render json: {
#         status: 200,
#         message: 'Logged out successfully.'
#       }, status: :ok
#     else
#       render json: {
#         status: 401,
#         message: "Couldn't find an active session."
#       }, status: :unauthorized
#     end
#   end
# end
