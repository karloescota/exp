defmodule ExpWeb.IncomeLive do
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

    incomes = Transactions.list_incomes(current_user, from, to, [:tag])
    total = Enum.reduce(incomes, Money.new(0), fn inc, acc -> Money.add(acc, inc.amount) end)

    {:ok,
     socket
     |> assign(:month, month)
     |> assign(:year, year)
     |> assign(:date, date)
     |> assign(:incomes, incomes)
     |> assign(:total, total)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Incomes")
    |> assign(:income, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Income")
    |> assign(:income, %Transaction{})
  end
end
