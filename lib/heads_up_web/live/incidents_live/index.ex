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
      <div class="incidents" >
        <div class="card" :for={incident <- @incidents}>
          <img src={incident.image_path} />
          <h2>{ incident.name }</h2>
          <div class="details">
            <div class="badge">
              { incident.status }
            </div>
            <div class="priority">
              { incident.priority }
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
