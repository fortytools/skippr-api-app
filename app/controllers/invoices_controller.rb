class InvoicesController < ApplicationController
  before_filter :init_api

  def show
    @invoice = @api::Invoice.find(params[:id])
  end

  def new
    @customers = @api::Customer.all
    @service_types = @api::ServiceType.all
  end

  def create
    
    unless params[:invoice_positions].blank?
      ips =  params[:invoice_positions].values.map do |hash| 
        @api::InvoicePosition.new(hash)
      end
    end
    invoice =  @api::Invoice.new(params[:invoice])
    invoice.invoice_positions_attributes = ips

    invoice.save
    redirect_to invoice_path(:id => invoice.id)
  end
end

