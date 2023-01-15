defmodule SlackCloneWeb.Live.Components.Messages do
  use SlackCloneWeb, :live_component

  alias SlackClone.Rooms

  @impl true
  def update(%{room_id: nil} = _assigns, socket) do
    {:ok, assign(socket, room: nil, invite_link_copied: false)}
  end

  @impl true
  def update(%{room_id: room_id} = _assigns, socket) do
    {:ok, assign(socket, room: Rooms.get_room!(room_id))}
  end

  @impl true
  def render(%{room: nil} = assigns) do
  	~H"""
    <div class="w-full flex flex-col p-4">
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
          <div class="text-gray-400 text-sm">
            Invite code: <%= @room.invite_code %>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 inline link" fill="none"
                 viewBox="0 0 24 24" stroke="currentColor" phx-click="copy_invite_code_link"
                 phx-value-code={@room.invite_code}
                 phx-target={@myself}>
                 <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
            <%= if @invite_link_copied do %>
              copied <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 inline" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("copy_invite_code_link", %{"code" => code}, socket) do
    base_url = SlackCloneWeb.Endpoint.url()
    link = base_url <> Routes.live_path(socket, SlackCloneWeb.Live.JoinRoom, code)

    {
      :noreply,
      socket
      |> assign(invite_link_copied: true)
      |> push_event("copy_invite_code_link", %{link: link})
    }
  end

  @impl true
  def handle_event("submit", %{"message" => %{"body" => message_body}}, socket) do
    if String.trim(message_body) == "" do
      {:noreply, socket}
    else
      message = %{
        "user_email" => socket.assigns.current_user_email,
        "timestamp" => DateTime.now!("Etc/UTC"),
        "body" => message_body
      }
      Phoenix.PubSub.broadcast(
        SlackClone.PubSub,
        "rooms",
        {:message, socket.assigns.room.id, message}
      )

      {:noreply, socket |> push_event("clear_input", %{field_id: "message_body"})}
    end
  end

  def handle_event("load-messages", nil, socket) do
    {:noreply, socket |> assign(messages: [])}
  end

  def handle_event("load-messages", messages, socket) do
    {:noreply, socket |> assign(messages: messages)}
  end
end
