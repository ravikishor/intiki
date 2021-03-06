class ProductVariant < ActiveRecord::Base
  belongs_to :product, :foreign_key => "product_id"
  has_many :cart_items
  has_many :order_to_product 
  
  validates :price,                 :presence => true,          :numericality => true
  
  def display_name
    name = ""
    if self.brand && self.brand != ""
      name = name+"["+self.brand+"] "
    end 
    value = (self.value ? self.value : "NA")
   return name+value + " ( Rs. " + self.price.to_s+" )"
  end
  
  def self.served_at(location)
    where("location = '' OR LOWER(location) = 'all' OR LOWER(location) = '#{location.downcase}'") 
  end
  
  def display_name_with_service
    name = ""
    if self.brand
      name = name+"["+self.brand+"] "
    end 
   return name+self.value + " ( Rs. " + self.price.to_s + " + Service Price: "+((self.service_price.to_i > 0) ? self.service_price.to_s : "0")+" )"
  end
end
