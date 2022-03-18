class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_rescue

  def record_not_found_rescue(exception)
    logger.info("#{exception.class}: " + exception.message)
    render json: {message: "We could not find the register you are looking for! :-("}, status: :not_found
  end
end
