class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_total
    self.invoice_items.joins(:bulk_discounts)
        .select("max((invoice_items.quantity * invoice_items.unit_price) * ( bulk_discounts.percentage/100)) AS discount_amount")
        .group("invoice_items.id") 
        .where("invoice_items.quantity >= bulk_discounts.quantity AND invoice_items.invoice_id = ?", self.id)
        .sum(&:discount_amount)
  end
        # .sum(:discount_amount)
        # require 'pry';binding.pry
        # InvoiceItem.joins(:bulk_discounts)
        # .select("bulk_discounts.name AS discount_name, invoice_items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS GROSS_REV, 
        # max( (invoice_items.quantity * invoice_items.unit_price) * ( bulk_discounts.percentage/100)  ) AS discounted_amount,  
        # SUM( (invoice_items.quantity * invoice_items.unit_price) - ((invoice_items.quantity * invoice_items.unit_price) * (bulk_discounts.percentage/100))) AS total_discounted_revenue")
        # .group("invoice_items.id, bulk_discounts.id")
        # .order(discount_amount: :desc)
      

  def calculate_discounted_revenue
    self.total_revenue - self.discounted_total
  end 

end
