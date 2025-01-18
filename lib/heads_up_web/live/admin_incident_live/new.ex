defmodule HeadsUpWeb.AdminIncidentLive.New do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    changeset = Incident.changeset(%Incident{}, %{})
    socket =
      socket
      |> assign(:page_title, "Create a new incident")
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-new">
      <.header>
        <h1>Create a new incident</h1>
      </.header>
      <.simple_form for={@form} phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:priority]} type="number" label="Priority" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Select Status"
          options={[:pending, :resolved, :archived]}
        />
        <.input field={@form[:image_path]} type="file" label="Image" />
        <:actions>
        <.button phx-disable-with="...Saving">Save</.button>
        </:actions>
      </.simple_form>
      <.back navigate={~p"/admin/incidents"}>
        Back
      </.back>
    </div>
    """
  end

  def handle_event("save", %{"incident" => incident_params}, socket) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident created successfully")
          |> push_navigate(to: ~p"/admin/incidents")
        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(:form, to_form(changeset))}
    end
  end
end
