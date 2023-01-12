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
    <div id={@id} class="w-full flex flex-col" phx-hook="LoadMessagesFromLocalStorage">
      <!-- Top bar -->
      <div class="border-b flex px-6 py-2 items-center">
        <div class="flex flex-col">
          <h3 class="text-gray-800 text-md mb-1 font-extrabold">#<%= @room.name %></h3>
          <div class="text-gray-600 text-sm">
            <%= @room.description %>
          </div>
          <%!-- <div class="text-gray-400 text-sm link">
            Invite code: <%= @room.invite_code %>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 inline" fill="none"
                 viewBox="0 0 24 24" stroke="currentColor"
                 phx-click="copy_invite_code_link"
                 phx-value-code={@room.invite_code}
                 phx-target={@myself}>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
            <%= if @invite_link_copied do %>
              copied <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 inline" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
            <% end %>
          </div> --%>
        </div>
      </div>
      <!-- Chat messages -->
      <%!-- <div class="px-6 py-4 flex-1 overflow-scroll-x">
        <%= for message <- @messages do %>
        <!-- A message -->
        <div class="flex items-start mb-4">
          <img src={gravatar_url(message["user_email"])} class="w-10 h-10 rounded mr-3" />
          <div class="flex flex-col">
            <div class="flex items-end">
              <span class="font-bold text-md mr-2 font-sans"><%= message["user_email"] %></span>
              <span class="text-gray-500 text-xs font-400"><%= message["timestamp"] %></span>
            </div>
            <p class="font-400 text-md text-gray-800 pt-1"><%= message["body"] %></p>
          </div>
        </div>
        <% end %>
      </div> --%>
      <%!-- <.form let={f} for={:message}, phx_submit="submit" phx-target={@myself}>
        <div class="flex m-6 rounded-lg border-2 border-gray-500 overflow-hidden">
          <%= submit "+", class: "text-3xl text-gray-500 px-3 border-r-2 border-gray-500" %>
          <%= text_input f, :body, class: "w-full px-5", id: "message_body" %>
        </div>
      </.form> --%>
    </div>
    """
  end
end
