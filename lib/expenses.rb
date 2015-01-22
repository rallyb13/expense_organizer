class Expense
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes[:id]
    @amount = attributes.fetch(:amount)
    @date = attributes.fetch(:date)
  end

  define_method(:==) do |another_expense|
    self.id() == another_expense.id() && self.name() == another_expense.name()
  end

  define_singleton_method(:all) do
    expenses = []
    table_data = DB.exec("SELECT * FROM expenses;")
    table_data.each() do |expense|
      id = expense.fetch('id').to_i()
      name = expense.fetch('name')
      amount = expense.fetch('amount').to_f()
      date = expense.fetch('date')
      expenses.push(Expense.new({ :id => id, :name => name, :amount => amount, :date => date}))
    end
    expenses
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO expenses (name, amount, date) VALUES ('#{@name}', #{@amount}, '#{@date}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  define_singleton_method(:find) do |search_id|
    Expense.all().each() do |expense|
      if expense.id().==(search_id)
        return expense
      end
    end
  end
end
