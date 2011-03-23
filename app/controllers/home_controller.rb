class HomeController < ApplicationController

  before_filter :init_api

  def show
    @invoices = @api::Invoice.all
    @service_types = @api::ServiceType.all
    @customers = @api::Customer.all
  end
end
