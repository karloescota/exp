defmodule ExpWeb.LiveHelpersTest do
  use ExpWeb.ConnCase

  alias ExpWeb.LiveHelpers

  describe "assign_defaults/2" do
    test "assigns current user to socket when user token is valid" do
      user = Exp.AccountsFixtures.user_fixture()
      token = Exp.Accounts.generate_user_session_token(user)

      socket = %Phoenix.LiveView.Socket{}
      session = %{"user_token" => token}

      assert %{assigns: %{current_user: nil}} = LiveHelpers.assign_defaults(socket, %{})
      assert %{assigns: %{current_user: ^user}} = LiveHelpers.assign_defaults(socket, session)
    end
  end
end
