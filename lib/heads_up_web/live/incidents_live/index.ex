defmodule HeadsUpWeb.IncidentsLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    socket = assign(socket, incidents: Incidents.all())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
    <.headline>
      <.icon name="hero-trophy-mini" />
      25 Incidents Resolved This Month!
      <:tagline :let={vibe}>
        Thanks for pitching in. <%= vibe %>
      </:tagline>
    </.headline>
      <div class="incidents" >
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incident, required: true

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@incident.image_path} />
      <h2>{ @incident.name }</h2>
      <div class="details">
        <.badge status={@incident.status} class="animate-spin" />
        <div class="priority">
          { @incident.priority }
        </div>
      </div>
    </div>
    """
  end
end
