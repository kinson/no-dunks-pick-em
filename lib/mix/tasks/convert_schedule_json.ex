defmodule Mix.Tasks.ConvertScheduleJson do
  @moduledoc """
  Load teams into the database if they are not already present.
  """

  use Mix.Task

  alias ClassicClips.Repo

  alias ClassicClips.PickEm.{ScheduledGame, Team}
  alias ClassicClips.PickEm.Season

  import Ecto.Query

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    [file_name | _] = args

    input_file = Path.join("./", file_name)

    current_season = Repo.one(from s in Season, where: s.current)

    teams_by_abbreviation = Repo.all(Team) |> Enum.group_by(& &1.abbreviation)

    slim_schedule =
      File.read!(input_file)
      |> Jason.decode!()
      |> extract_games()
      |> Enum.filter(fn %{away_abbr: away_abbr, home_abbr: home_abbr} ->
        Map.has_key?(teams_by_abbreviation, away_abbr) and
          Map.has_key?(teams_by_abbreviation, home_abbr)
      end)
      |> Enum.map(fn game ->
        away_team_id = Map.get(teams_by_abbreviation, game.away_abbr) |> hd() |> Map.get(:id)
        home_team_id = Map.get(teams_by_abbreviation, game.home_abbr) |> hd() |> Map.get(:id)

        ScheduledGame.changeset(%ScheduledGame{}, %{
          external_id: game.external_id,
          date: game.date,
          dt_utc: game.dt_utc,
          start_time_et: game.start_time_et,
          away_team_id: away_team_id,
          home_team_id: home_team_id,
          season_id: current_season.id
        })
      end)
      |> Enum.map(fn cs ->
        model = Ecto.Changeset.apply_action!(cs, :create)

        model
        |> Map.from_struct()
        |> Map.merge(%{
          inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
          updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
          id: Ecto.UUID.generate()
        })
        |> Map.drop([:__meta__, :away_team, :home_team, :season])
      end)

    Repo.insert_all(ScheduledGame, slim_schedule,
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: [:external_id]
    )
  end

  # Legacy data.nba.com format (schedules before 2026)
  defp extract_games(%{"lscd" => months}) do
    months
    |> Enum.flat_map(fn %{"mscd" => month} -> Map.get(month, "g") end)
    |> Enum.map(fn game ->
      %{
        "gid" => external_id,
        "gdte" => game_date,
        "stt" => game_start_et,
        "gdtutc" => gdutc,
        "utctm" => utctm,
        "v" => away_team,
        "h" => home_team
      } = game

      %{
        external_id: external_id,
        date: game_date,
        start_time_et: game_start_et,
        dt_utc: DateTime.new!(Date.from_iso8601!(gdutc), Time.from_iso8601!("#{utctm}:00")),
        away_abbr: away_team["ta"],
        home_abbr: home_team["ta"]
      }
    end)
  end

  # cdn.nba.com/static/json/staticData/scheduleLeagueV2_1.json format
  defp extract_games(%{"leagueSchedule" => %{"gameDates" => game_dates}}) do
    game_dates
    |> Enum.flat_map(&Map.get(&1, "games"))
    |> Enum.map(fn game ->
      %{
        "gameId" => external_id,
        "gameDateEst" => game_date_est,
        "gameTimeEst" => game_time_est,
        "gameDateTimeUTC" => game_dt_utc,
        "awayTeam" => %{"teamTricode" => away_abbr},
        "homeTeam" => %{"teamTricode" => home_abbr}
      } = game

      {:ok, dt_utc, _} = DateTime.from_iso8601(game_dt_utc)

      %{
        external_id: external_id,
        date: game_date_est |> String.slice(0, 10),
        start_time_et: format_start_time_et(game_time_est),
        dt_utc: dt_utc,
        away_abbr: away_abbr,
        home_abbr: home_abbr
      }
    end)
  end

  # "1900-01-01T19:00:00Z" -> "7:00 pm ET", matching the legacy "stt" format
  defp format_start_time_et(game_time_est) do
    {:ok, dt, _} = DateTime.from_iso8601(game_time_est)
    {hour, meridiem} = if dt.hour >= 12, do: {rem(dt.hour, 12), "pm"}, else: {dt.hour, "am"}
    hour = if hour == 0, do: 12, else: hour
    minute = dt.minute |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{hour}:#{minute} #{meridiem} ET"
  end
end
