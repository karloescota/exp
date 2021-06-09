defmodule ExpWeb.PageLive do
  use ExpWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session) |> assign(:page_title, "Home")}
  end
end
