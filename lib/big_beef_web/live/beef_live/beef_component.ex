defmodule BigBeefWeb.BeefLive.BeefComponent do
  use BigBeefWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
     <div class="beef-point" style="<%= "left: #{(@beef.game_time / 3600) * 100}%;top:#{100 - (((@beef.beef_count - 5)/21) * 100)}%;" %>">
      <p class="steak">&#129385;</p>
      <div class="beef-info">
        <p class="l-name"><%= @beef.player_first_name %> <%= @beef.player_last_name %></p>
        <p class="l-name">Beef Count: <%= @beef.beef_count %></p>
        <p class="l-name">Game Progress: <%= (@beef.game_time / (60 * 48)) * 100 |> trunc() %>%</p>
      </div>
     </div>
    """
  end
end
