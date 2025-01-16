defmodule HeadsUpWeb.IncidentsLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do
    socket = stream(socket, :incidents, Incidents.all())

    # IO.inspect(socket.assigns.streams.incidents, label: "MOUNT")

    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn socket ->
    #       IO.inspect(socket.assigns.streams.incidents, label: "AFTER RENDER")
    #       socket
    #   end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </.headline>
      <div class="incidents" id="incidents" phx-update="stream">
        <.incident_card :for={{dom_id, incident} <- @streams.incidents} id={dom_id} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, Incident, required: true
  attr :id, :string, required: true
  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incident/#{@incident.id}"} id={@id}>
      <div class="card">
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <.badge status={@incident.status} class="animate-spin" />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end
end
