class Category
  attr_reader(:id, :name, :percent)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes[:id]
    @percent = attributes[:percent]
  end

  define_method(:==) do |another_category|
    self.id() == another_category.id() && self.name() == another_category.name()
  end

  define_singleton_method(:all) do
    categories = []
    table_data = DB.exec("SELECT * FROM categories;")
    table_data.each() do |category|
      id = category.fetch('id').to_i()
      name = category.fetch('name')
      percent = category.fetch('percent').to_f()
      categories.push(Category.new({ :id => id, :name => name, :percent => percent }))
    end
    categories
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO categories (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  define_singleton_method(:find) do |search_id|
    Category.all().each() do |category|
      if category.id() == search_id
        return category
      end
    end
  end

  define_method(:delete) do
    DB.exec("DELETE FROM categories WHERE id = #{self.id()};")
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name)
    DB.exec("UPDATE categories SET name = '#{@name}' WHERE id = #{self.id()};")
  end

  define_method(:add_expense) do |expense|
    DB.exec("INSERT INTO categories_expenses (expense_id, category_id) VALUES (#{expense.id()}, #{self.id()});")
  end

  define_method(:expenses) do
    expenses = []
    db_expenses = DB.exec("SELECT expenses.* FROM
    categories JOIN categories_expenses ON (categories.id = categories_expenses.category_id)
             JOIN expenses ON (categories_expenses.expense_id = expenses.id)
             WHERE categories.id = #{self.id()};")
    db_expenses.each() do |expense|
      name = expense.fetch('name')
      amount = expense.fetch('amount').to_f()
      date = expense.fetch('date')
      id = expense.fetch('id').to_i()
      expenses.push(Expense.new({ :name => name, :amount => amount, :date => date, :id => id}))
    end
    expenses
  end
end
