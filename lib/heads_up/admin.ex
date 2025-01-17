defmodule HeadsUp.Admin do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_incident(params \\ %{}) do
    %Incident{
      name: params["name"],
      description: params["description"],
      priority: params["priority"] |> String.to_integer(),
      status: params["status"] |> String.to_existing_atom(),
      image_path: params["image_path"]
    }
    |> Repo.insert!()
  end
end
