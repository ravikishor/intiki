class Order < ActiveRecord::Base
  has_many :orders

  has_many :order_to_products
  has_many :product_variants,       :through => :order_to_products
  has_many  :products,              :through => :product_variants
  belongs_to :customer_management
  belongs_to :payment
  belongs_to :address
  before_save :create_displayid
  
  
  def toggle_active
    if self.active == true
      self.active = false
    else
      self.active = true
    end
    self.save
  end
  
  def to_param
    self.display_id
  end
  
  def addProduct(product_id_value)
    order_to_products.create(order_id: self.id, product_id: product_id_value)
  end
  
    ## Auto generated code using java @ Ravi
  ## Begin

  def self.admin_grid(params = {}, customer_id = "", active_state = nil, active = true)
    puts "orders admin_grid"
    grid = id_filter(params[:id]).
          customer_id_filter(customer_id).
          voucher_id_filter(params[:voucher_id]).
          payment_id_filter(params[:payment_id]).
          discount_filter(params[:discount]).
          discount_message_filter(params[:discount_message]).
          appointment_date_filter(params[:appointment_date]).
          duration_inHrs_filter(params[:duration_inHrs]).
          active_filter(active_state,active)
  end


  private

   def create_displayid
    self.display_id = id.to_s.rjust(5, '0')
   end

    def self.id_filter(id)
      if id.present?
        where("orders.id = ?", id)
      else
        all
      end
    end

    def self.customer_id_filter(customer_id)
      if customer_id.present?
        where("orders.customer_id = ?", customer_id)
      else
        all
      end
    end

    def self.voucher_id_filter(voucher_id)
      if voucher_id.present?
        where("orders.voucher_id = ?", voucher_id)
      else
        all
      end
    end

    def self.payment_id_filter(payment_id)
      if payment_id.present?
        where("orders.payment_id = ?", payment_id)
      else
        all
      end
    end

    def self.discount_filter(discount)
      if discount.present?
        where("orders.discount = ?", discount)
      else
        all
      end
    end

    def self.discount_message_filter(discount_message)
      if discount_message.present?
        where("orders.discount_message LIKE ?","%#{discount_message}%")
      else
        all
      end
    end

    def self.appointment_date_filter(appointment_date)
      if appointment_date.present?
        where("orders.appointment_date = ?", appointment_date)
      else
        all
      end
    end

    def self.duration_inHrs_filter(duration_inHrs)
      if duration_inHrs.present?
        where("orders.duration_inHrs = ?", duration_inHrs)
      else
        all
      end
    end

    def self.active_filter(state,active)
      if state.present?
        if active
          where("orders.active")
        else
          where("orders.active = false")
        end 
      else
        all
      end
    end

  ## Auto generated code using java @ Ravi
  ## end
end
