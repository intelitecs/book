class EmailsController < ApplicationController
  
  def create
    if EmailReceiver.receive(request)
      render json: {status: 'Ok'}
    else
      render json: {statusText: 'rejected', status: 403}
    end
    
  end
end
