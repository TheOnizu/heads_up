defmodule HeadsUpWeb.AdminIncidentLive.New do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents.Incident
  # use HeadsUpWeb.AdminLive

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Create a new incident")
      |> assign(:form, to_form(%{} , as: "incident"))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-new">
      <.header>
        <h1>Create a new incident</h1>
      </.header>
      <.simple_form for={@form} phx-change="validate" phx-submit="save">
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
        <.button>Save</.button>
        </:actions>
      </.simple_form>
      <.back navigate={~p"/admin/incidents"}>
        Back
      </.back>
    </div>
    """
  end
end
