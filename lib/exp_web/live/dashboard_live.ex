defmodule ExpWeb.DashboardLive do
  use ExpWeb, :live_view

  alias Exp.Transactions
  @impl true
  def mount(_params, %{"user_token" => _user_token} = session, socket) do
    socket = assign_defaults(socket, session)
    date = Date.utc_today()
    from = Date.beginning_of_month(date)
    to = Date.end_of_month(date)

    transactions = Transactions.list_transactions(socket.assigns.current_user, from, to, [:tag])

    %{income_total: income_total, expense_total: expense_total} =
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

    {:ok,
     socket
     |> assign(:year, date.year)
     |> assign(:month, date.month)
     |> assign(:transactions, transactions)
     |> assign(:income_total, income_total)
     |> assign(:expense_total, expense_total)}
  end
end
