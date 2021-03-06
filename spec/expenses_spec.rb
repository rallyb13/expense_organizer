require('spec_helper')

describe(Expense) do
  describe("#==") do
    it("will recognize when two variables are the same") do
      test_expense = Expense.new({:name => "Toys R Us", :amount => 200.00, :date => "2015-01-23" })
      test_expense2 = Expense.new({:name => "Toys R Us", :amount => 200.00, :date => "2015-01-23" })
      expect(test_expense).to(eq(test_expense2))
    end
  end

  describe(".all") do
    it("will start off empty") do
      expect(Expense.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("will save expense into the database") do
      test_expense = Expense.new({:name => "Toys R Us", :amount => 200.00, :date => "2015-01-23" })
      test_expense.save()
      expect(Expense.all()).to(eq([test_expense]))
    end
  end

  describe(".find") do
    it("returns an expense object given an id") do
      expense = Expense.new({ :name => "Burger", :amount => 10.00, :date => "2015-01-22"})
      expense.save()
      expect(Expense.find(expense.id())).to(eq(expense))
    end
  end

  describe("#delete") do
    it("deletes an expense from the database") do
      expense = Expense.new({ :name => "Burger", :amount => 10.00, :date => "2015-01-22"})
      expense.save()
      expense2 = Expense.new({:name => "Toys R Us", :amount => 200.00, :date => "2015-01-23" })
      expense2.save()
      expense.delete()
      expect(Expense.all()).to(eq([expense2]))
    end
  end

  describe("#update") do
    it("will update the name of an expense") do
      expense = Expense.new({ :name => "Burger", :amount => 10.00, :date => "2015-01-22"})
      expense.save()
      expense.update({ :name => "Veggie Burger"})
      expect(expense.name()).to(eq("Veggie Burger"))
    end
  end

end
