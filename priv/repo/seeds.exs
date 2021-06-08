# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Exp.Repo.insert!(%Exp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Exp.{Accounts, Tags, Expenses}

{:ok, user} = Accounts.register_user(%{email: "admin@test.com", password: "password1234"})

{:ok, food_tag} =
  Tags.create_tag(user, %{
    name: "Food",
    type: "expense"
  })

{:ok, transportation_tag} =
  Tags.create_tag(user, %{
    name: "Transportation",
    type: "expense"
  })

{:ok, salary_tag} =
  Tags.create_tag(user, %{
    name: "Salary",
    type: "income"
  })

Expenses.create_expense(user, %{
  tag_id: food_tag.id,
  name: "Dinner",
  amount: 30000,
  date: Date.utc_today()
})

Expenses.create_expense(user, %{
  tag_id: food_tag.id,
  name: "Lunch",
  amount: 22000,
  date: Date.utc_today()
})

Expenses.create_expense(user, %{
  tag_id: transportation_tag.id,
  name: "Bus fare",
  amount: 12000,
  date: Date.utc_today()
})
