defmodule ExpWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(ExpWeb.ModalComponent, modal_opts)
  end

  def assign_defaults(socket, session) do
    user_token = Map.get(session, "user_token")

    Phoenix.LiveView.assign_new(socket, :current_user, fn ->
      user_token && Exp.Accounts.get_user_by_session_token(user_token)
    end)
  end

  def currency_format(amount) when is_integer(amount) do
    currency = :erlang.float_to_binary(amount / 100, decimals: 2)
    "P #{currency}"
  end
end
