class Api::V1::SessionsController < Devise::SessionsController
    respond_to :json

  private

  def respond_with(resource, _opts = {})
  token = request.env['warden-jwt_auth.token']
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: UserSerializer.new(resource).serializable_hash
      }, status: :ok, headers: { 'Authorization' => "Bearer #{token}" }
    else
      render json: {
        status: { code: 401, message: 'Unauthorized' }
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    # Check if there was an authenticated user during this request
    if current_user
      # User was successfully signed out
      render json: {
        status: { code: 200, message: 'Logged out successfully.' }
      }, status: :ok
    else
      # No user was signed in to begin with
      render json: {
        status: { code: 401, message: 'No active session' }
      }, status: :unauthorized
    end
  end
end