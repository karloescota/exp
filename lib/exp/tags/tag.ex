defmodule Exp.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    field :type, :string

    belongs_to :user, Exp.Accounts.User

    timestamps()
  end

  @valid_types ["income", "expenses"]

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :type, :user_id])
    |> validate_required([:name, :type, :user_id])
    |> validate_inclusion(:type, @valid_types)
    |> unique_constraint([:name, :user_id])
  end
end
