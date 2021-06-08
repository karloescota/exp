defmodule Exp.TransactionsTest do
  use Exp.DataCase

  alias Exp.Transactions.Transaction
  alias Exp.Transactions
  alias Exp.Tags
  alias Exp.AccountsFixtures

  test "create expense" do
    user = AccountsFixtures.user_fixture()
    {:ok, tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})

    assert {:ok, %Transaction{} = transaction} =
             Transactions.create_expense(user, %{
               name: "Dinner",
               tag_id: tag.id,
               amount: 13000,
               date: ~D[2021-06-08]
             })

    assert transaction.name == "Dinner"
    assert transaction.amount == Money.new(13000)
    assert transaction.date == ~D[2021-06-08]
    assert transaction.tag_id == tag.id
    assert transaction.user_id == user.id
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
