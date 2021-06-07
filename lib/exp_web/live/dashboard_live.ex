defmodule ExpWeb.DashboardLive do
  use ExpWeb, :live_view

  @impl true
  def mount(_params, %{"user_token" => _user_token} = session, socket) do
    socket = assign_defaults(socket, session)
    current_user = socket.assigns.current_user

    date = Date.utc_today()
    expenses = Exp.Expenses.list_expenses_for(current_user, date)

    {:ok,
     socket
     |> assign(year: date.year)
     |> assign(month: date.month)
     |> assign(expenses: expenses)}
  end
end
