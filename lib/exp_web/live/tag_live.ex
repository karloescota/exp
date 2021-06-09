defmodule ExpWeb.TagLive do
  use ExpWeb, :live_view

  alias Exp.Tags
  alias Exp.Tags.Tag

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(socket, session)
    tags = Tags.list_tags()

    {:ok,
     socket
     |> assign(:tags, tags)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Tags")
    |> assign(:tag, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tag")
    |> assign(:tag, %Tag{})
  end
end
