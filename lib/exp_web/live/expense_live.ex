defmodule ExpWeb.ExpenseLive do
  use ExpWeb, :live_view

  alias Exp.Transactions
  alias Exp.Transactions.Transaction

  @impl true
  def mount(%{"year" => year, "month" => month}, session, socket) do
    socket = assign_defaults(socket, session)
    current_user = socket.assigns.current_user

    year = String.to_integer(year)
    month = String.to_integer(month)
    {:ok, date} = Date.new(year, month, 1)
    from = Date.beginning_of_month(date)
    to = Date.end_of_month(date)

    expenses = Transactions.list_expenses(current_user, from, to, [:tag])
    total = Enum.reduce(expenses, Money.new(0), fn exp, acc -> Money.add(acc, exp.amount) end)

    {:ok,
     socket
     |> assign(:month, month)
     |> assign(:year, year)
     |> assign(:date, date)
     |> assign(:expenses, expenses)
     |> assign(:total, total)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Expenses")
    |> assign(:expense, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Transaction{})
  end
end
