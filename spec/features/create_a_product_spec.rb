require 'rails_helper'

feature 'Product creation' do
  scenario 'staff creates a product', :js do
    staff = create(:staff, :admin)
    new_product_attributes = {
      'name' => 'Product Jellyfish',
      'description' => 'A product description',
      'product_type' => 'VMware VM',
      'img' => 'products/aws_ec2.png',
      'active' => true,
      'setup_price' => 10.0000,
      'monthly_price' => 10.0000,
      'hourly_price' => 10.0000,
      'provisioning_answers' => {
        'ram_size' => 2,
        'disk_size' => 50,
        'cpu_count' => '4'
      }
    }

    login_as(staff)

    visit '/admin/products/create'

    fill_in 'Name', with: new_product_attributes['name']
    fill_in 'Description', with: new_product_attributes['description']
    select(new_product_attributes['product_type'])
    selectize('#productImg', option: "[src$='#{new_product_attributes['img']}']")
    check('Active?')
    fill_in 'Setup Price', with: new_product_attributes['setup_price']
    fill_in 'Monthly Price', with: new_product_attributes['monthly_price']
    fill_in 'Hourly Price', with: new_product_attributes['hourly_price']
    fill_in 'RAM size in GB', with: new_product_attributes['provisioning_answers']['ram_size']
    fill_in 'Disk Size in GB', with: new_product_attributes['provisioning_answers']['disk_size']
    select(new_product_attributes['provisioning_answers']['cpu_count'])
    click_on 'CREATE PRODUCT'

    expect(page).to have_content('Product was successfully added.')
    expect(Product.last.attributes).to include new_product_attributes
  end

  def selectize(container, option:)
    find("#{container} .selectize-input").click
    find("#{container} #{option}").click
  end
end
