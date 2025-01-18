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
    %Incident{}
    |> Incident.changeset(params)
    |> IO.inspect(label: "CHANGESET")
    |> Repo.insert()
  end

  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    incident
    |> Incident.changeset(attrs)
  end

  def get_incident!(id) do
    Incident
    |> Repo.get!(id)
  end

  def update_incident(%Incident{} = incident, attrs \\ %{}) do
    incident
    |> Incident.changeset(attrs)
    |> Repo.update()
  end

  def delete_incident(%Incident{} = incident) do
    Repo.delete(incident)
  end
end
