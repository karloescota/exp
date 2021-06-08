defmodule ExpWeb.IncomeLive.FormComponent do
  use ExpWeb, :live_component

  alias Exp.Transactions
  alias Exp.Tags

  @impl true
  def update(%{income: income, current_user: current_user} = assigns, socket) do
    changeset = Transactions.change_transaction(income)
    tags = Tags.list_income_tags(current_user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:tags, tags)}
  end

  @impl true
  def handle_event("validate", %{"income" => income_params}, socket) do
    changeset =
      socket.assigns.income
      |> Transactions.change_transaction(income_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"income" => income_params}, socket) do
    save_income(socket, socket.assigns.action, income_params)
  end

  defp save_income(socket, :edit, income_params) do
    case Transactions.update_transaction(socket.assigns.income, income_params) do
      {:ok, _income} ->
        {:noreply,
         socket
         |> put_flash(:info, "Income updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_income(socket, :new, income_params) do
    case Transactions.create_transaction(socket.assigns.current_user, income_params) do
      {:ok, _income} ->
        {:noreply,
         socket
         |> put_flash(:info, "Income created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
