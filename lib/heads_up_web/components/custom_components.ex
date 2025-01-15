defmodule HeadsUpWeb.CustomComponents do
  use HeadsUpWeb, :html

  attr :status, :atom, values: [:pending, :resolved, :canceled], default: :pending
  attr :class, :string, default: nil
  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :pending && "text-lime-600 border-lime-600",
      @status == :resolved && "text-amber-600 border-amber-600",
      @status == :canceled && "text-red-600 border-red-600",
      @class
    ]}>
      { @status }
    </div>
    """
  end
end
