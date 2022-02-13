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
    #Only if current user has enough balance, we create the order
    if current_user.balance >= @current_cart.sub_total
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

      #Save the order
      @order.save!

      #Destroy the cart related to the order
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil

      puts "/////////////////"
      puts "balance: "
      puts current_user.balance
      #Substract balance from user
      current_user.balance -= @current_cart.sub_total
      current_user.save
      puts "balance: "
      puts current_user.balance
      puts "/////////////////"
      redirect_to root_path
    else

      redirect_to root_path, notice: "You don't have enough money for this transaction!"
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :email, :address)
  end
end
