class Admin::Merchandise::ProductVariantsController < AdminController
  before_action :set_product_variant, only: [:edit, :update, :destroy]
    
   # GET /product_variants/new
  def new
    @product_variant = ProductVariant.new
  end

  # GET /product_variants/1/edit
  def edit
  end

  # POST /product_variants
  # POST /product_variants.json
  def create 
    puts "entered the dragon #{params[:product_id]}"
    @product_variant = ProductVariant.new(product_variant_params)
    
    respond_to do |format|
      if @product_variant.save
         if params[:product_id].present?
            @product_variant.update_columns(product_id: params[:product_id])
            puts "updated #{@product_variant.product_id}"
        end
        format.html { redirect_back_or(@product_variant, notice: 'Product variant was successfully created.') }
        format.json { render action: 'show', status: :created, location: @product_variant }
      else
        format.html { render action: 'new' }
        format.json { render json: @product_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_variants/1
  # PATCH/PUT /product_variants/1.json
  def update
    respond_to do |format|
      if @product_variant.update(product_variant_params)
        format.html { redirect_to @product_variant, notice: 'Product variant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_variants/1
  # DELETE /product_variants/1.json
  def destroy
    store_location()
    @product_variant.destroy
    respond_to do |format|
      format.html { redirect_back_or(product_variants_url) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_variant
      @product_variant = ProductVariant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_variant_params
      params.require(:product_variant).permit(:product_id, :location, :price, :value)
    end
end