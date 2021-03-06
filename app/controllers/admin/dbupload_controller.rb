class Admin::DbuploadController < AdminController
  def index

  end
  
  def updateDb
    require 'csv'
    @insert_status = false
    @insert_dir = Rails.root.to_s + '/app/assets/images/products/'
    @insert_file = @insert_dir + params[:export_file]
    if @insert_file.present?
      CSV.foreach(@insert_file, :headers => true , :encoding => 'ISO-8859-1') do |row|
        if row['name'] && row['name'] != ""
          @product = Product.find_or_create_by(name: row['name'].gsub(/<\/?[^>]*>/, '').strip)
          @product.update_attributes( :image  =>  row['image'],
          :description => row['description'],
          :meta_description=> row['meta_description'],
          :active => row['active'],
          :nature => row['nature'],
          :video => row['video'],
          :variant_matric => row['variant_matric'],
          :menu_parent => row['menu_parent'],
          :how2fix => row['how2fix'])
          @product.save

          if @product
            @insert_status = true
            @pre_product = @product
          else
            @insert_status = false
            @insert_error = @insert_error+row['name']+" "
          end
        end
        if (@product  || (row['price'] && row['price'] != "" && @insert_status))
          @location = row['location']
          if row['location'] && row['location'] == ""
            @location = "all"
          end
          @productVariant = ProductVariant.find_or_create_by(:product_id =>  @product? @product.id: @pre_product.id,
                              :value => row['value'], :location => @location)
          @productVariant.save
          @productVariant.update_attributes(:price => ((row['price'].to_f > 0)?  row['price'].to_f : 0))
        end

        @product = nil
      end
    end

    if @insert_error && @insert_error != ""
      flash[:alert] = "Following Products are not inserted Properly: "+@insert_error
    end
    redirect_to admin_dbupload_index_path
  end
  def uploadFile
    uploaded_io = params[:upload_file]
    @upload_file = Rails.root.to_s + '/app/assets/images/products/' +  uploaded_io.original_filename
    File.open( @upload_file, 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end
end