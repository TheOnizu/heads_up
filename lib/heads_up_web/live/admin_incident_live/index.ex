defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""

    <div class="admin-index">
      <.header>
        <h1><%= @page_title %></h1>
        <:actions>
          <.link patch={~p"/admin/incidents/new"}>
            New Incident
          </.link>
        </:actions>
      </.header>
      <.table id="incidents" rows={@streams.incidents}>
        <:col :let={{_dom_id, incident}} label="Name">
          <.link navigate={~p"/incident/#{incident.id}"}><%= incident.name %></.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="Description">
          <%= incident.description %>
        </:col>
        <:col :let={{_dom_id, incident}} label="Priority">
          <%= incident.priority %>
        </:col>
        <:col :let={{_dom_id, incident}} label="Status">
          <.badge status={incident.status} />
        </:col>
        <:action :let={{_dom_id, incident}}>
          <.link patch={~p"/admin/incidents/#{incident.id}/edit"}>
            Edit
          </.link>
          <.link patch={~p"/admin/incidents/#{incident.id}/delete"}>
            Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end
end
