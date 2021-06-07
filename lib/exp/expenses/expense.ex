defmodule Exp.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :name, :string
    field :amount, :integer
    field :date, :date

    belongs_to :tag, Exp.Tags.Tag

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :amount, :date])
    |> validate_required([:name, :amount, :date])
  end
end
