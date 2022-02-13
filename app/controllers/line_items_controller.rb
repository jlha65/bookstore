class LineItemsController < ApplicationController
  def create
    # Find associated book and current cart
    chosen_book = Book.find(params[:book_id])
    current_cart = @current_cart

    # If cart already has this book then find the relevant line_item and iterate quantity otherwise create a new line_item for this book
    if current_cart.books.include?(chosen_book)
      # Find the line_item with the chosen_book
      @line_item = current_cart.line_items.find_by(book_id: chosen_book)
      puts "cart already has this book"

      # Iterate the line_item's quantity by one
      @line_item.quantity += 1
    else
        puts "cart doesnt have this book"
      @line_item = LineItem.new
      puts current_cart.inspect
      puts chosen_book.inspect
      @line_item.cart = current_cart
      @line_item.book = chosen_book
    end

    puts "\n\n\n Line Item to be saved:"
    puts @line_item.inspect
    # Save and redirect to cart show path
    @line_item.save!
    puts "\n\n\n Saved. \n\n\n"

    puts @line_item.inspect
    redirect_to cart_path(current_cart)
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    redirect_to cart_path(@current_cart)
  end

  def add_quantity
    @line_item = LineItem.find(params[:id])
    @line_item.quantity += 1
    @line_item.save
    redirect_to cart_path(@current_cart)
  end
  
  def reduce_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.quantity -= 1
    end
    @line_item.save
    redirect_to cart_path(@current_cart)
  end

  private

  def line_item_params
    params.require(:line_item).permit(:quantity, :book_id, :cart_id)
  end
end
