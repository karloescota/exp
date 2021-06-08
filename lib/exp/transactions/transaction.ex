defmodule Exp.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :name, :string
    field :amount, Money.Ecto.Amount.Type
    field :date, :date

    belongs_to :tag, Exp.Tags.Tag
    belongs_to :user, Exp.Accounts.User

    timestamps()
  end

  @required_attrs [:name, :amount, :date, :tag_id, :user_id]

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
  end
end
