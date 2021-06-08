defmodule ExpWeb.DashboardLive do
  use ExpWeb, :live_view

  @impl true
  def mount(_params, %{"user_token" => _user_token} = session, socket) do
    socket = assign_defaults(socket, session)
    date = Date.utc_today()

    {:ok,
     socket
     |> assign(year: date.year)
     |> assign(month: date.month)}
  end
end
