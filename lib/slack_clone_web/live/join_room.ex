defmodule SlackCloneWeb.Live.JoinRoom do
  use SlackCloneWeb, :live_view

  alias SlackClone.Rooms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"invite_code" => invite_code} = _params, _url, %{assigns: %{current_user: user}} = socket) do
    room = Rooms.get_room_by!(invite_code: invite_code)
    {:ok, _room} = Rooms.join(user, room)

    {
      :noreply,
      socket |> put_flash(:info, "Room #{room.name} successfully joined!") |> Phoenix.LiveView.redirect(to: "/")
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    """
  end
end
