defmodule HelloWeb.LightLive do
  use HelloWeb, :live_view

  def mount(_params, _session, socket) do
    socket = socket |> assign(light_on: false)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Light</h1>
    <button phx-click="toggle_light">Toggle Light</button>
    <span id="light">
      <%= if @light_on, do: "Light is on", else: "Light is off" %>
    </span>
    """
  end

  def handle_event("toggle_light", _params, socket) do
    socket = socket |> assign(light_on: !socket.assigns.light_on)
    {:noreply, socket}
  end
end
