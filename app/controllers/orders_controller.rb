class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    puts "Creating \n\n"
    @order = Order.new(order_params)
    @current_cart.line_items.each do |item|
      puts "\n Cart item: \n"
      puts item.inspect
      @order.line_items << item
      puts "\n\n\n"
      puts @order.line_items.inspect
      puts "\n\n\n"
      item.cart_id = nil
    end
    puts @order.inspect
    puts "\n\n\n"
    puts @order.line_items.inspect
    @order.save!
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil
    redirect_to root_path
  end
  
  private
    def order_params
      params.require(:order).permit(:name, :email, :address)
    end
end
