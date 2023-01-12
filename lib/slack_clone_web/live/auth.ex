defmodule SlackCloneWeb.Live.Auth do
  import Phoenix.LiveView

  alias SlackClone.Accounts
  alias SlackClone.Accounts.User

  def on_mount(:default, _params, %{"user_token" => token} = _session, socket) do
    case Accounts.get_user_by_session_token(token) do
      %User{} = user -> {:cont, assign(socket, current_user: user)}
      _error -> {:halt, redirect(socket, to: "/users/log_in")}
    end
  end

  def on_mount(:default, _params, _session, socket) do
    {:halt, redirect(socket, to: "/users/log_in")}
  end
end
