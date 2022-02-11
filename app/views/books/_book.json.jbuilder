json.extract! book, :id, :book_id, :title, :description, :author, :price, :stock, :available, :created_at, :updated_at
json.url book_url(book, format: :json)
