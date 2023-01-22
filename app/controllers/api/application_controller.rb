module Api
  class ApplicationController < ActionController::API
    def render_error_message(model)
      render json: { errors: model.errors.messages }, status: :unprocessable_entity
    end

    def render_unauthorized_message
      render json: { message: 'You are not authorized'}, status: :unauthorized
    end
  end
end
