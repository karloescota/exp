defmodule Exp.ExpensesTest do
  use Exp.DataCase

  alias Exp.Expenses

  describe "expenses" do
    alias Exp.Expenses.Expense

    @valid_attrs %{amount: 42, date: ~D[2010-04-17], name: "some name"}
    @update_attrs %{amount: 43, date: ~D[2011-05-18], name: "some updated name"}
    @invalid_attrs %{amount: nil, date: nil, name: nil}

    def expense_fixture(attrs \\ %{}) do
      user = Exp.AccountsFixtures.user_fixture()

      {:ok, tag} = Exp.Tags.create_tag(user, %{name: "Dinner", type: "expenses"})

      attrs = Enum.into(attrs, @valid_attrs)

      {:ok, expense} = Expenses.create_expense(user, tag, attrs)

      expense
    end

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      user = Exp.AccountsFixtures.user_fixture()
      {:ok, tag} = Exp.Tags.create_tag(user, %{name: "Dinner", type: "expenses"})
      assert {:ok, %Expense{} = expense} = Expenses.create_expense(user, tag, @valid_attrs)
      assert expense.amount == 42
      assert expense.date == ~D[2010-04-17]
      assert expense.name == "some name"
    end

    test "create_expense/1 with invalid data returns error changeset" do
      user = Exp.AccountsFixtures.user_fixture()
      {:ok, tag} = Exp.Tags.create_tag(user, %{name: "Dinner", type: "expenses"})
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(user, tag, @invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, @update_attrs)
      assert expense.amount == 43
      assert expense.date == ~D[2011-05-18]
      assert expense.name == "some updated name"
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
      assert expense == Expenses.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end
  end
end
