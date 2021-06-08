defmodule Exp.Transactions do
  import Ecto.Query, warn: false
  alias Exp.Repo

  alias Exp.Transactions.Transaction
  alias Exp.Accounts.User

  # def list_expenses do
  #   Repo.all(Expense)
  # end

  # def list_expenses_for(user, date, preloads \\ []) do
  #   query =
  #     from expense in Expense,
  #       where:
  #         expense.date >= ^Date.beginning_of_month(date) and
  #           expense.date <= ^Date.end_of_month(date) and
  #           expense.user_id == ^user.id

  #   Repo.all(query) |> Repo.preload(preloads)
  # end

  # def get_expense!(id), do: Repo.get!(Expense, id)

  # def create_expense(user, attrs \\ %{}) do
  #   %Expense{user_id: user.id}
  #   |> Expense.changeset(attrs)
  #   |> Repo.insert()
  # end

  # def update_expense(%Expense{} = expense, attrs) do
  #   expense
  #   |> Expense.changeset(attrs)
  #   |> Repo.update()
  # end

  # def delete_expense(%Expense{} = expense) do
  #   Repo.delete(expense)
  # end

  # def change_expense(%Expense{} = expense, attrs \\ %{}) do
  #   Expense.changeset(expense, attrs)
  # end

  def create_expense(%User{} = user, attrs \\ %{}) do
    %Transaction{user_id: user.id}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def list_expenses(user, from, to, preloads \\ []) do
    query =
      from transaction in Transaction,
        join: tag in assoc(transaction, :tag),
        where:
          tag.type == "expense" and
            transaction.date >= ^from and
            transaction.date <= ^to and
            transaction.user_id == ^user.id,
        order_by: [desc: :date]

    Repo.all(query) |> Repo.preload(preloads)
  end

  def update_expense(expense, attrs) do
    expense
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  def change_expense(%Transaction{} = expense, attrs \\ %{}) do
    Transaction.changeset(expense, attrs)
  end
end
