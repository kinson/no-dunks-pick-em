defmodule BigBeefWeb.BeefLive.GraphComponent do
  use BigBeefWeb, :live_component

  import BigBeefWeb.BeefLive.Helpers

  def render(assigns) do
    ~H"""
    <div id="graph" class={is_active(@page_type, "live")}>
      <p class="beef-card-label">
        Keep Up With Beefs As They Happen
      </p>
      <div class="graph-floater">
        <p class="active-count">
          <%= if @active_game_count == 1,
            do: "1 active game",
            else: "#{@active_game_count} active games" %>
          <span class={if @active_game_count > 0, do: "active"}></span>
        </p>
        <div class="graph-container">
          <div id="beef-graph">
            <div class="graph-lines">
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
              <div class="beef-graph-line"></div>
            </div>
            <div id="beef-line">
              <p>BIG BEEF LINE</p>
            </div>
            <div id="regulation-end-line"></div>
            <%= for beef <- @beefs do %>
              <BigBeefWeb.BeefLive.BeefComponent.render beef={beef} />
            <% end %>
            <div class="x-axis-label oneq">
              <p>1Q</p>
            </div>
            <div class="x-axis-label twoq">
              <p>2Q</p>
            </div>
            <div class="x-axis-label threeq">
              <p>3Q</p>
            </div>
            <div class="x-axis-label fourq">
              <p>4Q</p>
            </div>
            <div class="x-axis-label endreg">
              <p>Buzzer</p>
            </div>
            <div class="x-axis-label twoot">
              <p>2OT</p>
            </div>
            <div class="y-axis-label">
              <p>5</p>
            </div>
            <div class="y-axis-label ten-off">
              <p>10</p>
            </div>
            <div class="y-axis-label fift-off">
              <p>15</p>
            </div>
            <div class="y-axis-label twen-off">
              <p>20</p>
            </div>
            <div class="y-axis-label twefiv-off">
              <p>25</p>
            </div>
            <p class="y-axis-title">
              BEEF COUNT
            </p>
            <p class="x-axis-title">
              GAME TIME
            </p>
            <p class="last-updated-time">
              last updated: <%= @last_updated %>
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
