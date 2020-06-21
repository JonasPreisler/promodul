module ControllerResponse
  def rest_respond_service(service)
    if !service.respond_to?(:errors)
      rest_response_body(service)
    elsif service.errors.any?
      render json: { errors: service.errors }, status: error_response_code(service)
    else
      rest_response_body(service)
    end
  end

  private
  def create_action?(result)
    if params[:action].match?(/^create/)
      render json: result, status: 201
      return true
    end
    false
  end

  def respond_action_json_view(service, action)
    result = service.send(action)

    return if create_action?(result)

    render json: result, status: (result ? 200 : 204)
  end

  def respond_json_view(service)
    result = service.json_view

    return if create_action?(result)

    render json: result, status: (result ? 200 : 204)
  end

  def rest_response_body(service)
    action_json_view = params[:action] + "_json_view".chomp

    if service.respond_to?(action_json_view)
      respond_action_json_view(service, action_json_view)
    elsif service.respond_to?(:json_view)
      respond_json_view(service)
    else
      render json: {} , status: 204
    end
  end

  def error_response_code(service)
    return service.response_code if service.respond_to?("response_code") && service.response_code != nil

    codes = {
        post: 400,
        get: 404,
        put: 400,
        delete: 404
    }
    codes[request.method_symbol] || 500
  end

end

