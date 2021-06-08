defmodule ExpWeb.ExpenseLive do
  use ExpWeb, :live_view

  @impl true
  def mount(%{"year" => year, "month" => month}, session, socket) do
    socket = assign_defaults(socket, session)
    current_user = socket.assigns.current_user

    year = String.to_integer(year)
    month = String.to_integer(month)
    {:ok, date} = Date.new(year, month, 1)

    expenses = Exp.Expenses.list_expenses_for(current_user, date, [:tag])

    total = Enum.reduce(expenses, 0, fn exp, acc -> acc + exp.amount end)

    {:ok,
     socket
     |> assign(month: month)
     |> assign(year: year)
     |> assign(date: date)
     |> assign(expenses: expenses)
     |> assign(total: total)}
  end
end
