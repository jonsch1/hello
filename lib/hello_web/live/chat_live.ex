defmodule HelloWeb.ChatLive do
  use HelloWeb, :live_view

  @topic "chat"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Hello.PubSub, @topic)
    end

    messages = Hello.Repo.all(Hello.Chat.Message)
    {:ok, assign(socket, messages: messages, current_message: "")}
  end

  def handle_event("send_message", %{"message" => content}, socket) when content != "" do
    # Create message in database
    {:ok, message} = %Hello.Chat.Message{}
    |> Hello.Chat.Message.changeset(%{content: content})
    |> Hello.Repo.insert()
    
    Phoenix.PubSub.broadcast_from(
      Hello.PubSub,
      self(),
      @topic,
      {:new_message, message}
    )

    messages = socket.assigns.messages ++ [message]
    {:noreply, assign(socket, messages: messages, current_message: "")}
  end

  def handle_event("delete_message", %{"id" => id}, socket) do
    # Find and delete the message
    message = Hello.Repo.get!(Hello.Chat.Message, id)
    {:ok, _} = Hello.Repo.delete(message)
    
    # Broadcast deletion to other clients
    Phoenix.PubSub.broadcast_from(
      Hello.PubSub,
      self(),
      @topic,
      {:delete_message, message.id}
    )

    messages = Enum.filter(socket.assigns.messages, fn m -> m.id != message.id end)
    {:noreply, assign(socket, messages: messages)}
  end

  def handle_info({:new_message, message}, socket) do
    messages = socket.assigns.messages ++ [message]
    {:noreply, assign(socket, messages: messages)}
  end

  def handle_info({:delete_message, message_id}, socket) do
    messages = Enum.filter(socket.assigns.messages, fn m -> m.id != message_id end)
    {:noreply, assign(socket, messages: messages)}
  end

  def render(assigns) do
    ~H"""
    <div class="chat-container">
      <div class="messages" id="messages">
        <%= for message <- @messages do %>
          <div class="message" id={"message-#{message.id}"}>
            <p>
              <%= message.content %>
              <button phx-click="delete_message" phx-value-id={message.id}>Delete</button>
            </p>
          </div>
        <% end %>
      </div>

      <form phx-submit="send_message">
        <input
          type="text"
          name="message"
          value={@current_message}
          placeholder="Type a message..."
        />
        <button type="submit">Send</button>
      </form>
    </div>
    """
  end

end 