defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def all do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def filter_incidents(params) do
    Incident
    |> with_status(params["status"])
    |> search_by(params["q"])
    |> sort_by(params["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status)
    when status in ~w(pending canceled resolved) do
      where(query, status: ^status)
  end

  defp with_status(query,_status), do: query

  defp search_by(query, q) when q in ["", nil], do: query
  defp search_by(query, q), do: where(query, [r], like(r.name, ^"%#{q}%"))

  defp sort_by(query, "name") do
    order_by(query,  :name)
  end
  defp sort_by(query, "priority") do
    order_by(query, asc: :priority)
  end

  defp sort_by(query, "status") do
    order_by(query, asc: :status)
  end

  defp sort_by(query, _) do
    order_by(query, asc: :name)
  end

  def urgent_incidents(incident) do
    Incident
    |> where(status: :pending)
    |> where([i], i.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
