defmodule SlackCloneWeb.Live.IndexView do
  use SlackCloneWeb, :live_view

  alias SlackCloneWeb.Live.Components

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_room_id: nil)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full border shadow bg-white">
      <div class="flex">
        <.live_component module={Components.Sidebar} id="sidebar" current_user={@current_user} />
        <.live_component module={Components.Messages} id="messages" room_id={@current_room_id} />
      </div>
    </div>
    """
  end
end
