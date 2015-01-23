require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/expenses")
require("./lib/categories")
require("pg")
require("pry")

DB = PG.connect({:dbname => "expense_organizer"})


get("/") do
  erb(:index)
end

post("/categories") do
  category_name = params.fetch('category_name')
  Category.new({ :name => category_name }).save()
  erb(:index)
end

delete("/categories") do
  category_id = params.fetch('category_id').to_i()
  Category.find(category_id).delete()
  erb(:index)
end

delete("/expenses") do
  expense_id = params.fetch('expense_id').to_i()
  Expense.find(expense_id).delete()
  erb(:index)
end

get("/categories/:id") do
  # @category = Category.find(params.fetch("category_id").to_i())
  @id = params.fetch("category_id").to_i()
  erb(:category)
end

post("/expenses") do
  name = params.fetch('expense_name')
  amount = params.fetch('expense_amount').to_f()
  date = params.fetch('expense_date')
  category_id = params.fetch('category_id').to_i()
  category = Category.find(category_id)
  expense = Expense.new({ :name => name, :amount => amount, :date => date })
  expense.save()
  category.add_expense(expense)
  erb(:category)
end
