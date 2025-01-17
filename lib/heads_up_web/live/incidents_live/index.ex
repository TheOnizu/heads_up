defmodule HeadsUpWeb.IncidentsLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do

    # IO.inspect(socket.assigns.streams.incidents, label: "MOUNT")

    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn socket ->
    #       IO.inspect(socket.assigns.streams.incidents, label: "AFTER RENDER")
    #       socket
    #   end)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:incidents, Incidents.filter_incidents(params), reset: true)
      |> assign(form: to_form(params))

      {:noreply, socket}
  end

  def handle_event("filter", params, socket) do
    # IO.inspect(Incidents.filter_incidents(params), label: "FILTERED")
    params =
      params
      |> Map.take(["q", "status", "sort_by"])
      |> Map.reject(fn {_, v} -> v == ""  end)
      socket = push_patch(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- <pre>
      <%= inspect(@form, pretty: true) %>
      <%= inspect(@form[:q], pretty: true) %>
    </pre> --%>
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </.headline>

      <.filter_form form={@form} />

      <div class="incidents" id="incidents" phx-update="stream">
        <div id="empty" class="no-results only:block hidden">
          No incidents found. Try changing your filters.
        </div>
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          id={dom_id}
          incident={incident}
        />
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

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} phx-change="filter">
      <.input field={@form[:q]} placeholder="Search..." />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Select Status"
        options={[:pending, :resolved, :archived]}
      />
      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort By"
        options={[:name, :priority, :status]}
      />
      <.link patch={~p"/incidents"}>
      reset
      </.link>
    </.form>
    """
  end
end
