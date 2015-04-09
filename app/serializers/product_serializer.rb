# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  active               :boolean
#  img                  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  deleted_at           :datetime
#  setup_price          :decimal(10, 4)   default(0.0)
#  hourly_price         :decimal(10, 4)   default(0.0)
#  monthly_price        :decimal(10, 4)   default(0.0)
#  provisioning_answers :json
#  product_type         :string(255)
#
# Indexes
#
#  index_products_on_deleted_at  (deleted_at)
#

class ProductSerializer < ApplicationSerializer
  attributes :id, :name, :description, :active, :img, :created_at, :updated_at, :deleted_at, :setup_price, :hourly_price, :monthly_price, :provisioning_answers, :product_type

  def product_type
    object.product_type.name
  end
end
