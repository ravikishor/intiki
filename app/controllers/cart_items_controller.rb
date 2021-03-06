class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:show, :edit, :update, :destroy]
  # GET /cart_items
  # GET /cart_items.json
  def index
    update_cart_items
  end

  # GET /cart_items/1
  # GET /cart_items/1.json
  def show
    update_cart_items
  end

  # GET /cart_items/new
  def new
    @cart_item = CartItem.new
  end

  # GET /cart_items/1/edit
  def edit
  end

  # POST /cart_items
  # POST /cart_items.json
  def create
    @cart = current_cart
    if params[:include_service].present? 
      @product = ProductVariant.find(params[:cart_item][:product_id_with_service]) 
    else
       @product = ProductVariant.find(params[:cart_item][:product_id]) 
    end
       
    if !(params[:cart_item][:quantity].to_i > 0)
      params[:cart_item][:quantity] = "1"
    end   
    
    @cart_item = @cart.add_products({:product_id => @product.id, :price => @product.price,:quantity => params[:cart_item][:quantity],:cart_id => @cart.id, :include_service => params[:include_service]})
   
    respond_to do |format|
      if @cart_item.save 
        update_cart_items
        @isShowCartItems = "yes"
        format.html { redirect_back_or(request.env["HTTP_REFERER"]) }
        format.json { render action: 'show', status: :created, location: @cart_item }
        format.js 
      else
        format.html { render action: 'new' }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        
      end
    end
  end

  # PATCH/PUT /cart_items/1
  # PATCH/PUT /cart_items/1.json
  def update
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to @cart_item }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/1
  # DELETE /cart_items/1.json
  def destroy
    store_location()
    @cart_item.destroy
    update_cart_items
    respond_to do |format|
      format.html { redirect_back_or(cart_items_url) }
      format.json { head :no_content }
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cart_item_params
    params.require(:cart_item).permit(:product_id, :price, :quantity, :cart_id)
  end
end
