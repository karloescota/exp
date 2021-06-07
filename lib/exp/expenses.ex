defmodule Exp.Expenses do
  import Ecto.Query, warn: false
  alias Exp.Repo

  alias Exp.Expenses.Expense

  def list_expenses do
    Repo.all(Expense)
  end

  def list_expenses_for(user, date, preloads \\ []) do
    query =
      from expense in Expense,
        where:
          expense.date >= ^Date.beginning_of_month(date) and
            expense.date <= ^Date.end_of_month(date) and
            expense.user_id == ^user.id

    Repo.all(query) |> Repo.preload(preloads)
  end

  def get_expense!(id), do: Repo.get!(Expense, id)

  def create_expense(user, tag, attrs \\ %{}) do
    %Expense{user_id: user.id, tag_id: tag.id}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end
end
