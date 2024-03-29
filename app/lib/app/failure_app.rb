module App
  class FailureApp < Devise::FailureApp
    def respond
      if request.controller_class.to_s.start_with? 'Api::'
        json_api_error_response
      else
        super
      end
    end

    def json_api_error_response
      self.status = 401
      self.content_type = 'application/json'
      self.response_body = { message: "You need to sign in or sign up" }.to_json
    end
  end
end