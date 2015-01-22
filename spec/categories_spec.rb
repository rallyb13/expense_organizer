require('spec_helper')

describe(Category) do
  describe("#==") do
    it("will recognize when two variables are the same") do
      test_category = Category.new({:name => "food"})
      test_category2 = Category.new({:name => "food"})
      expect(test_category).to(eq(test_category2))
    end
  end

  describe(".all") do
    it("will start off empty") do
      expect(Category.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("will save category into the database") do
      test_category = Category.new({:name => "travel"})
      test_category.save()
      expect(Category.all()).to(eq([test_category]))
    end
  end

  describe(".find") do
      it("will find a specific category by its id") do
      test_category = Category.new({:name => "pets"})
      test_category.save()
      expect(Category.find(test_category.id())).to(eq(test_category))
    end
  end

  describe("#delete") do
    it("will delete a category from the database") do
      category1 = Category.new({:name => "travel"})
      category1.save()
      category2 = Category.new({:name => "food"})
      category2.save()
      category1.delete()
      expect(Category.all()).to(eq([category2]))
    end
  end

  describe("#update") do
    it("will change the name of a category") do
      category = Category.new({:name => "food"})
      category.save()
      category.update({:name => "groceries"})
      expect(category.name()).to(eq("groceries"))
    end
  end

  describe("#expenses") do
    it("will add an expense into a specific category") do
      category = Category.new({:name => "food"})
      category.save()
      expense = Expense.new({ :name => "Burger", :amount => 10.00, :date => "2015-01-22"})
      expense.save()
      category.add_expense(expense)
      expect(category.expenses()).to(eq([expense]))
    end
  end
end
