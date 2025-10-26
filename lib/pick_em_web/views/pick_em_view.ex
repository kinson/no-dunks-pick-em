defmodule PickEmWeb.BigBeefView do
  use PickEmWeb, :view

  alias ClassicClips.PickEm.Player

  def format_time(time) do
    six_hour_back_offset = -1 * 60 * 60 * 6

    time
    |> DateTime.add(six_hour_back_offset, :second)
    |> DateTime.to_date()
    |> Date.to_string()
  end

  def name(%Player{first_name: first_name, last_name: last_name}) do
    "#{last_name}, #{first_name}"
  end
end
