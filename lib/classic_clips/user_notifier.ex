defmodule ClassicClips.UserNotifier do
  import Swoosh.Email
  alias ClassicClips.Mailer

  require Logger

  def deliver_new_matchup(%{name: name, email: email, matchup: matchup}) do
    {:ok, datestring} =
      matchup.tip_datetime
      |> ClassicClips.PickEm.to_new_york()
      |> Timex.format("{Mfull} {D}, {YYYY}")

    matchupline =
      "#{matchup.away_team.abbreviation} @ #{matchup.home_team.abbreviation} (#{matchup.favorite_team.abbreviation} #{matchup.spread})"

    result =
      new()
      |> to({name, email})
      |> from({"Pick 'Em", "info@nodunkspickem.com"})
      |> subject("New Matchup")
      |> put_provider_option(:template_id, System.get_env("SENDGRID_MATCHUP_TEMPLATE_ID"))
      |> put_provider_option(:dynamic_template_data, %{
        link: "https://nodunkspickem.com",
        datestring: datestring,
        matchupline: matchupline
      })
      |> Mailer.deliver()

    Logger.notice("Email sent to #{email}", name: name, email: email, result: result)
  end
end
