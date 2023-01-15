defmodule SlackCloneWeb.Live.Components.Messages do
  use SlackCloneWeb, :live_component

  alias SlackClone.Rooms

  @impl true
  def update(%{room_id: nil} = _assigns, socket) do
    {:ok, assign(socket, room: nil)}
  end

  @impl true
  def update(%{room_id: room_id} = _assigns, socket) do
    {:ok, assign(socket, room: Rooms.get_room!(room_id))}
  end

  @impl true
  def render(%{room: nil} = assigns) do
  	~H"""
    <div class="w-full flex flex-col">
      No room has been joined yet. To join a room click on its name on the sidebar to your left.
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full flex flex-col">
      <!-- Top bar -->
      <div class="border-b flex px-6 py-2 items-center">
        <div class="flex flex-col">
          <h3 class="text-gray-800 text-md mb-1 font-extrabold">#<%= @room.name %></h3>
          <div class="text-gray-600 text-sm">
            <%= @room.description %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
