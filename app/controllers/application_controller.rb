class ApplicationController < ActionController::API
  rescue_from ActiveRecord::StatementInvalid, with: :render_invalid_parameters
  rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
  rescue_from ActionController::ParameterMissing, with: :render_invalid_parameters
  rescue_from NoMethodError, with: :render_invalid_parameters
  rescue_from TypeError, with: :render_invalid_parameters
  rescue_from ArgumentError, with: :render_invalid_parameters

  def render_invalid_parameters
    render json: ErrorSerializer.invalid_parameters, status: :bad_request
  end

  def render_resource_not_found(error)
    render json: ErrorSerializer.record_not_found(error.message), status: :not_found
  end

  def render_record_invalid(error)
    render json: ErrorSerializer.record_invalid(error.message), status: :bad_request
  end
end
