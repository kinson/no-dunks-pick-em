defmodule PickEmWeb.PickEmLive.Settings do
  use PickEmWeb, :live_view

  alias ClassicClips.{PickEm}
  alias PickEmWeb.PickEmLive.{Theme, User}

  @impl true
  def mount(_params, session, socket) do
    {:ok, user} = User.get_or_create_user(session)

    theme = Theme.get_theme_from_session(session)

    # Create form for emoji settings
    emoji_settings_data = %{
      "emojis_enabled" => Theme.get_emojis_enabled(theme),
      "emojis_only" => Theme.get_emoji_only_enabled(theme)
    }

    emoji_settings_form = Phoenix.Component.to_form(emoji_settings_data, as: :team_emojis)

    # Create form for custom emojis (initially empty, populated when editing)
    custom_emojis_form = Phoenix.Component.to_form(%{}, as: :custom_emojis)

    {:ok,
     socket
     |> assign(:page, "settings")
     |> assign(:east_teams, get_east_teams())
     |> assign(:theme_data, Jason.encode!(theme))
     |> assign(:theme, theme)
     |> assign(:west_teams, get_west_teams())
     |> assign(:is_editing_teams, false)
     |> assign(:submit_emoji_enabled, false)
     |> assign(:emoji_settings_form, emoji_settings_form)
     |> assign(:custom_emojis_form, custom_emojis_form)
     |> assign(:user, user)}
  end

  @impl true
  def handle_event("edit", _, socket) do
    # When entering edit mode, populate custom emojis form with current values
    theme = socket.assigns.theme
    east_teams = socket.assigns.east_teams
    west_teams = socket.assigns.west_teams

    custom_emojis_data =
      (east_teams ++ west_teams)
      |> Enum.map(fn team ->
        {to_string(team.id), Theme.get_emoji_for_team(team, theme)}
      end)
      |> Map.new()

    custom_emojis_form = Phoenix.Component.to_form(custom_emojis_data, as: :custom_emojis)

    {:noreply,
     socket
     |> assign(:is_editing_teams, true)
     |> assign(:custom_emojis_form, custom_emojis_form)}
  end

  def handle_event("cancel", _, socket) do
    # Reset custom emojis form when canceling
    custom_emojis_form = Phoenix.Component.to_form(%{}, as: :custom_emojis)

    {:noreply,
     socket
     |> assign(:is_editing_teams, false)
     |> assign(:custom_emojis_form, custom_emojis_form)}
  end

  def handle_event(
        "toggle_emojis",
        %{"team_emojis" => team_emojis},
        socket
      ) do
    theme =
      socket.assigns.theme
      |> Map.merge(team_emojis)

    # Update emoji settings form
    emoji_settings_data = %{
      "emojis_enabled" => Theme.get_emojis_enabled(theme),
      "emojis_only" => Theme.get_emoji_only_enabled(theme)
    }

    emoji_settings_form = Phoenix.Component.to_form(emoji_settings_data, as: :team_emojis)

    {:noreply,
     socket
     |> assign(:is_editing_teams, false)
     |> assign(:submit_emoji_enabled, true)
     |> assign(:theme, theme)
     |> assign(:theme_data, Jason.encode!(theme))
     |> assign(:emoji_settings_form, emoji_settings_form)
     |> PickEmWeb.PickEmLive.NotificationComponent.show("Updated emoji preference")}
  end

  defp get_east_teams do
    PickEm.get_cached_teams_for_conference(:east)
  end

  defp get_west_teams do
    PickEm.get_cached_teams_for_conference(:west)
  end
end
