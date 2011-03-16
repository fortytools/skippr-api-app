class HomeController < ApplicationController

  before_filter :init_api

  def show
    @foo = @api::Invoice.find(6165).inspect

  end
end
