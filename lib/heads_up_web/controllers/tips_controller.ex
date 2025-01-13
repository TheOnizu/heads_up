defmodule HeadsUpWeb.TipsController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Tips

  def index(conn, _params) do
    emojis = ~w(💚 💜 💙) |> Enum.random() |> String.duplicate(5)

    tips = Tips.list_tips()
    conn = merge_assigns(conn, tips: tips, emojis: emojis)
    IO.inspect(conn)
    render(conn, :index, layout: false)
  end

  def show(conn, %{"id" => id}) do
    tip = Tips.get_tip(id)
    conn = merge_assigns(conn, tip: tip)
    render(conn, :show, layout: false)
  end
end
