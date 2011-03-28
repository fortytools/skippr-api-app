class HomeController < ApplicationController

  before_filter :init_api

  def show
    @invoices = @api::Invoice.all
    @service_types = @api::ServiceType.all
    @customer_states = @api::CustomerState.all
    if params[:search].blank?
      @customers = @api::Customer.all
    else
      @customers = @api::Customer.find(:all, :params => {:email => params[:search]})
    end
  end
end
