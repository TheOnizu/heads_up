defmodule HeadsUpWeb.AdminIncidentLive.New do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Admin

  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(incident, %{})

    socket
      |> assign(:page_title, "Create a new incident")
      |> assign(:form, to_form(changeset))
      |> assign(:incident, incident)

  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    changeset = Admin.change_incident(incident, %{})

    socket
      |> assign(:page_title, "Edit incident")
      |> assign(:form, to_form(changeset))
      |> assign(:incident, incident)
  end

  def render(assigns) do
    ~H"""
    <div class="admin-new">
      <.header>
        <h1>Create a new incident</h1>
      </.header>
      <pre>
        <%= inspect(@live_action, pretty: true) %>
      </pre>
      <.simple_form for={@form} phx-submit="save" phx-change="validate">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" phx-debounce="blur" />
        <.input field={@form[:priority]} type="number" label="Priority" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Select Status"
          options={[:pending, :resolved, :canceled]}
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

  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset = Admin.change_incident(%Incident{}, incident_params)
    {:noreply, socket |> assign(:form, to_form(changeset, action: :validate))}
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
