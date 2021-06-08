defmodule Exp.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :name, :string
    field :amount, Money.Ecto.Amount.Type
    field :date, :date

    belongs_to :tag, Exp.Tags.Tag
    belongs_to :user, Exp.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :amount, :date, :user_id, :tag_id])
    |> validate_required([:name, :amount, :date, :user_id, :tag_id])
    |> validate_money(:amount)
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [amount: "must be greater than 0"]
    end)
  end
end
