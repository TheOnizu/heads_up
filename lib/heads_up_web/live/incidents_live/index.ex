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
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :status, :atom, values: [:pending, :resolved, :canceled], default: :pending
  attr :class, :string, default: nil
  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :pending && "text-lime-600 border-lime-600",
      @status == :resolved && "text-amber-600 border-amber-600",
      @status == :canceled && "text-red-600 border-red-600",
      @class
    ]}>
      { @status }
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
