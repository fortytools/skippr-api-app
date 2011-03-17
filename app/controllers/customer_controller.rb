class CustomerController < ApplicationController
  before_filter :init_api

  def show
    @customer = @api::Customer.find(params[:id])
    #raise @customer.inspect
  end
end
