defmodule Exp.TransactionsTest do
  use Exp.DataCase

  alias Exp.Transactions.Transaction
  alias Exp.Transactions
  alias Exp.Tags
  alias Exp.AccountsFixtures

  describe "expenses" do
    test "create expense" do
      user = AccountsFixtures.user_fixture()
      {:ok, tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})

      assert {:ok, %Transaction{} = expense} =
               Transactions.create_expense(user, %{
                 name: "Dinner",
                 tag_id: tag.id,
                 amount: 13000,
                 date: ~D[2021-06-08]
               })

      assert expense.name == "Dinner"
      assert expense.amount == Money.new(13000)
      assert expense.date == ~D[2021-06-08]
      assert expense.tag_id == tag.id
      assert expense.user_id == user.id
    end

    test "list user's expenses in a given date range" do
      user = AccountsFixtures.user_fixture()
      {:ok, expense_tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})
      {:ok, income_tag} = Tags.create_tag(user, %{name: "Salary", type: "income"})

      {:ok, %Transaction{} = first_expense} =
        Transactions.create_expense(user, %{
          name: "Dinner",
          tag_id: expense_tag.id,
          amount: 13000,
          date: ~D[2021-06-08]
        })

      {:ok, %Transaction{} = second_expense} =
        Transactions.create_expense(user, %{
          name: "Dinner",
          tag_id: expense_tag.id,
          amount: 14000,
          date: ~D[2021-06-09]
        })

      {:ok, %Transaction{} = _past_expense} =
        Transactions.create_expense(user, %{
          name: "Past Lunch",
          tag_id: expense_tag.id,
          amount: 13000,
          date: ~D[2021-05-31]
        })

      {:ok, %Transaction{} = _future_expense} =
        Transactions.create_expense(user, %{
          name: "Future Lunch",
          tag_id: expense_tag.id,
          amount: 13000,
          date: ~D[2021-07-01]
        })

      {:ok, %Transaction{} = _income} =
        Transactions.create_expense(user, %{
          name: "June Salary",
          tag_id: income_tag.id,
          amount: 25000,
          date: ~D[2021-06-08]
        })

      assert Transactions.list_expenses(user, ~D[2021-06-01], ~D[2021-06-30]) == [
               second_expense,
               first_expense
             ]
    end

    test "update expense" do
      user = AccountsFixtures.user_fixture()
      {:ok, expense_tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})

      {:ok, %Transaction{} = expense} =
        Transactions.create_expense(user, %{
          name: "Dinner",
          tag_id: expense_tag.id,
          amount: 13000,
          date: ~D[2021-06-08]
        })

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_expense(expense, %{name: "Late dinner"})

      assert transaction.name == "Late dinner"
    end

    test "change expense returns a changeset" do
      assert %Ecto.Changeset{} = Transactions.change_expense(%Transaction{})
    end
  end

  describe "incomes" do
    test "create income" do
      user = AccountsFixtures.user_fixture()
      {:ok, tag} = Tags.create_tag(user, %{name: "Salary", type: "income"})

      assert {:ok, %Transaction{} = income} =
               Transactions.create_transaction(user, %{
                 name: "June pay",
                 tag_id: tag.id,
                 amount: 25000,
                 date: ~D[2021-06-08]
               })

      assert income.name == "June pay"
      assert income.amount == Money.new(25000)
      assert income.date == ~D[2021-06-08]
      assert income.tag_id == tag.id
      assert income.user_id == user.id
    end

    test "list user's earnings in a given date range" do
      user = AccountsFixtures.user_fixture()
      {:ok, expense_tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})
      {:ok, income_tag} = Tags.create_tag(user, %{name: "Salary", type: "income"})

      {:ok, %Transaction{} = _expense} =
        Transactions.create_transaction(user, %{
          name: "Dinner",
          tag_id: expense_tag.id,
          amount: 13000,
          date: ~D[2021-06-08]
        })

      {:ok, %Transaction{} = first_income} =
        Transactions.create_transaction(user, %{
          name: "June Salary",
          tag_id: income_tag.id,
          amount: 25000,
          date: ~D[2021-06-08]
        })

      {:ok, %Transaction{} = second_income} =
        Transactions.create_transaction(user, %{
          name: "Tenant payment",
          tag_id: income_tag.id,
          amount: 10000,
          date: ~D[2021-06-30]
        })

      {:ok, %Transaction{} = _past_income} =
        Transactions.create_transaction(user, %{
          name: "May pay",
          tag_id: income_tag.id,
          amount: 25000,
          date: ~D[2021-05-01]
        })

      {:ok, %Transaction{} = _future_income} =
        Transactions.create_transaction(user, %{
          name: "July pay",
          tag_id: income_tag.id,
          amount: 25000,
          date: ~D[2021-07-01]
        })

      assert Transactions.list_incomes(user, ~D[2021-06-01], ~D[2021-06-30]) == [
               second_income,
               first_income
             ]
    end
  end
end
