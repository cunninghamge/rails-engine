class ApplicationController < ActionController::API
  rescue_from ActiveRecord::StatementInvalid, with: :render_invalid_parameters
  rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found

  def render_invalid_parameters
    render json: ErrorSerializer.invalid_parameters, status: :bad_request
  end

  def render_resource_not_found(error)
    render json: ErrorSerializer.record_not_found(error.message), status: :not_found
  end
end
