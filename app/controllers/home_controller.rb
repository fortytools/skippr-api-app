class HomeController < ApplicationController

  before_filter :init_api

  def show
    @foo = @api::Invoice.find(6165).inspect
    @service_types = @api::ServiceType.all
    @customers = @api::Customer.all
  end
end
