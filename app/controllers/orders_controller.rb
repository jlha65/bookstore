class OrdersController < ApplicationController
  def index
    @orders = Order.all
    @user_orders = Array.new
    @line_items = LineItem.all
    @line_items.each do |item|
      book = Book.find(item.book_id)
      if book.user_id == current_user.id
        # puts book.user_id
        # puts current_user.id
        # puts item.order_id
        # puts Order.find(item.order_id)
        if item.order_id
          @user_orders << Order.find(item.order_id)
        end
      end
    end
    puts @user_orders.inspect
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    #Notice of success/failure
    notice = "Order succesfully created!"
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

      available = true
      @order.line_items.each do |item|
        puts "\n\n\n"
        puts "Book: "
        bookStock = (Book.find(item.book_id)).stock
        puts bookStock.inspect
        if item.quantity > bookStock
          available = false
          notice = "Book(s) you want to buy are out of stock or unavailable."
        end
      end
      if available
        #Remove stock
        @order.line_items.each do |item|
          book = Book.find(item.book_id)
          book.stock -= item.quantity
          book.save
        end

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
      end
      redirect_to root_path, notice: notice
    else
      redirect_to root_path, notice: "You don't have enough money for this transaction!"
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :email, :address)
  end
end
