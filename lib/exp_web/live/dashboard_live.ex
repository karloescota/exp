defmodule ExpWeb.DashboardLive do
  use ExpWeb, :live_view

  alias Exp.Transactions

  @impl true
  def mount(_params, %{"user_token" => _user_token} = session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(%{"year" => year, "month" => month}, _url, socket) do
    date = Date.new!(String.to_integer(year), String.to_integer(month), 15)
    {:noreply, set_assigns(socket, date)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    now = Date.utc_today()
    {:noreply, set_assigns(socket, Date.new!(now.year, now.month, 15))}
  end

  defp set_assigns(socket, date) do
    from = Date.beginning_of_month(date)
    to = Date.end_of_month(date)

    transactions = Transactions.list_transactions(socket.assigns.current_user, from, to, [:tag])

    %{income_total: income_total, expense_total: expense_total} = calculate_totals(transactions)

    socket
    |> assign(:page_title, "Dashboard")
    |> assign(:date, date)
    |> assign(:previous_date, Date.add(date, -30))
    |> assign(:next_date, Date.add(date, 30))
    |> assign(:transactions, transactions)
    |> assign(:income_total, income_total)
    |> assign(:expense_total, expense_total)
    |> assign(:balance, Money.subtract(income_total, expense_total))
  end

  defp calculate_totals(transactions) do
    Enum.reduce(
      transactions,
      %{income_total: Money.new(0), expense_total: Money.new(0)},
      fn t, acc ->
        case t.tag.type do
          "income" ->
            Map.update!(acc, :income_total, &Money.add(&1, t.amount))

          "expense" ->
            Map.update!(acc, :expense_total, &Money.add(&1, t.amount))
        end
      end
    )
  end
end
