defmodule Exp.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :name, :string
      add :amount, :integer
      add :date, :date
      add :tag_id, references(:tags, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:expenses, [:user_id])
    create index(:expenses, [:tag_id])
  end
end
