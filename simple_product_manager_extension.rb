require 'json_fields'

# Set the default attachment sizes
PRODUCT_ATTACHMENT_SIZES={:thumbnail => '75x75>', :product => '250x250>'}
		
class SimpleProductManagerExtension < Radiant::Extension
	version "0.8.1"
	description "Manages Products and Product Categories for use across the site."
	url "http://github.com/jstirk/radiant-simple-product-manager/tree/master"
	
	define_routes do |map|
		map.namespace 'admin' do |admin|
			admin.resources :products, :member => { :remove => :get }
			admin.resources :categories, :member => { :remove => :get }
			admin.product_image 'products/upload_image/:product_id', :controller => 'products', :action => 'upload_image', :method => :post
			admin.delete_product_image 'products/delete_image/:id', :controller => 'products', :action => 'delete_image', :method => :delete
			admin.move_product 'products/move/:id/:d', :controller => 'products', :action => 'move', :method => :get
			admin.move_product_image 'products/move_image/:id/:d', :controller => 'products', :action => 'move_image', :method => :get
			admin.move_category 'categories/move/:id/:d', :controller => 'categories', :action => 'move', :method => :get
		end
		map.connect 'products/:id', :controller => 'categories', :action => 'show', :id => /\d+(-[A-Za-z\-]+)?/
		map.connect 'products/:category_id/:id', :controller => 'products', :action => 'show'
	end
	
	def activate
		admin.tabs.add "Products", "/admin/products", :after => "Layouts", :visibility => [:all]
		Page.send :include, SimpleProductManagerTag

		# If our RadiantConfig settings are blank, set them up now
		Radiant::Config['simple_product_manager.product_fields'] ||= ''
		Radiant::Config['simple_product_manager.category_fields'] ||= ''
		Radiant::Config['simple_product_manager.product_layout'] ||= 'Product'
		Radiant::Config['simple_product_manager.category_layout'] ||= 'Category'
	end
	
	def deactivate
		admin.tabs.remove "Products"
	end
	
end
