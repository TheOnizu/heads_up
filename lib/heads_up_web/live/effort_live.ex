defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :responders_updated, 2000)
    end

    socket = assign(socket, responders: 0, minutes_per_responder: 10, total_effort: 0, page_title: "Effort")
    {:ok, socket }
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      <section>
          <button phx-click="increment" phx-value-increment={4}>add</button>
          <div>
            {@responders}
          </div>
          &times;
          <div>
            {@minutes_per_responder}
          </div>
          =
          <div>
            {@responders * @minutes_per_responder}
          </div>
        </section>
        <form phx-submit="set-minutes-per-responder">
            <label>Minutes Per Responder:</label>
            <input type="number" name="minutes" value={@minutes_per_responder} />
        </form>
    </div>
    """
  end

  def handle_event("increment", %{"increment" => increment}, socket) do
    {:noreply, update(socket, :responders, &(&1 + String.to_integer(increment)))}
  end

  def handle_event("set-minutes-per-responder", %{"minutes" => minutes}, socket) do
    socket = assign(socket, minutes_per_responder: String.to_integer(minutes))
    {:noreply, socket}
  end

  def handle_info(:responders_updated, socket) do
    Process.send_after(self(), :responders_updated, 2000)
    {:noreply, update(socket, :responders, &(&1 + 3))}
  end
end
