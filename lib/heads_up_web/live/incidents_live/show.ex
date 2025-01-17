defmodule HeadsUpWeb.IncidentsLive.Show do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident!(id)

    socket =
      socket
      |> assign(:incident, incident)
      |> assign(:page_title, incident.name)
      |> assign_async(:urgent_incidents, fn ->
        # {:error, "error je ne sais pas pk ? "} end)
        {:ok, %{urgent_incidents:  Incidents.urgent_incidents(incident)}} end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <pre :if={false}>
      <%= inspect(@urgent_incidents, pretty: true) %>
    </pre>
    <div class="incident-show">
      <div class="incident">
        <img src={@incident.image_path} />
        <section>
          <div class="... text-lime-600 border-lime-600">
            canceled
          </div>
          <header>
            <h2>{@incident.name}</h2>
            <div class="priority">
             <p>{@incident.priority}</p>
            </div>
          </header>
          <div class="description">
            <p>{@incident.description}</p>
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.urgent_incidents incidents={@urgent_incidents} />
        </div>
      </div>
    </div>
    """
  end

  attr :incidents, :list, required: true

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <.async_result :let={result} assign={@incidents} >
        <:loading>
          <div class="loading">
            <div class="spinner"></div>
          </div>
        </:loading>
        <:failed :let={{:error, reason}}>
          <div class="failed" >
            <p><%= reason %></p>
            </div>
        </:failed>
        <ul class="incidents">
          <.link :for={incident <- result} navigate={~p"/incident/#{incident.id}"}>
            <li>
              <img src={incident.image_path} /> {incident.name}
            </li>
          </.link>
        </ul>
      </.async_result>
    </section>
    """
  end
end
