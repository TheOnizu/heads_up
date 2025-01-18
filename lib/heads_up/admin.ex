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
    %Incident{}
    |> Incident.changeset(params)
  end
end
