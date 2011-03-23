class InvoiceController < ApplicationController
  before_filter :init_api

  def show
    @invoice = @api::Invoice.find(params[:id])
  end
end

