class LineItem < ApplicationRecord
    belongs_to :book
    belongs_to :cart, optional: true
    belongs_to :order, optional: true

    # LOGIC
    def total_price
        self.quantity * self.book.price
    end
end
