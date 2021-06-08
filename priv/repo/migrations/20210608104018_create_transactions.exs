defmodule Exp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :name, :string
      add :amount, :integer
      add :date, :date
      add :tag_id, references(:tags, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:user_id])
  end
end
