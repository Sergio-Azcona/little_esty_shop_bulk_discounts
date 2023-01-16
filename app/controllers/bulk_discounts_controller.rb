class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id]) 
  end

  def show
    @merchant = Merchant.find(params[:merchant_id]) 
    @discount = @merchant.bulk_discounts.find(params[:id])
    # require 'pry';binding.pry
  end

  def new
    @merchant = Merchant.find(params[:merchant_id]) 
    @new_discount = @merchant.bulk_discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id]) 
    @new_discount = @merchant.bulk_discounts.create(discount_params)

    if @new_discount.save
      flash.notice = "Update Successful"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.notice = "Unsuccessful - Please Try Again"
      render :new
    end
  end




  private

  def discount_params
    params.permit(:name, :quantity, :percentage)
  end
end