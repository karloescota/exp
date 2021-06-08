defmodule ExpWeb.TagLive.FormComponent do
  use ExpWeb, :live_component

  alias Exp.Tags

  @impl true
  def update(%{tag: tag} = assigns, socket) do
    changeset = Tags.change_tag(tag)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tag" => tag_params}, socket) do
    changeset =
      socket.assigns.tag
      |> Tags.change_tag(tag_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tag" => tag_params}, socket) do
    save_expense(socket, socket.assigns.action, tag_params)
  end

  defp save_expense(socket, :new, tag_params) do
    case Tags.create_tag(socket.assigns.current_user, tag_params) do
      {:ok, _expense} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tag created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
