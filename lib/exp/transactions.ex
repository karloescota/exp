defmodule Exp.Transactions do
  import Ecto.Query, warn: false
  alias Exp.Repo

  alias Exp.Transactions.Transaction
  alias Exp.Accounts.User

  def list_transactions(user, from, to, preloads \\ []) do
    query =
      from transaction in Transaction,
        where:
          transaction.date >= ^from and
            transaction.date <= ^to and
            transaction.user_id == ^user.id,
        order_by: [desc: :date]

    Repo.all(query) |> Repo.preload(preloads)
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

  def list_incomes(user, from, to, preloads \\ []) do
    query =
      from transaction in Transaction,
        join: tag in assoc(transaction, :tag),
        where:
          tag.type == "income" and
            transaction.date >= ^from and
            transaction.date <= ^to and
            transaction.user_id == ^user.id,
        order_by: [desc: :date]

    Repo.all(query) |> Repo.preload(preloads)
  end

  def create_transaction(%User{} = user, attrs \\ %{}) do
    %Transaction{user_id: user.id}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def update_transaction(transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
