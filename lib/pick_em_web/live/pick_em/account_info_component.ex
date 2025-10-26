defmodule PickEmWeb.PickEmLive.AccountInfoComponent do
  use PickEmWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-auto md:w-full ml-10 md:ml-20 py-4 px-8 bg-gray-100 shadow-lg rounded-lg flex flex-row">
      <img
        class="max-h-24 mr-8 ml-0 my-2"
        src={Routes.static_path(@socket, "/images/google_logo.png")}
        alt="Google Sign In"
      />
      <div class="flex flex-col w-full">
        <div class="flex flex-row my-2">
          <p class="my-0 mr-2 text-nd-pink text-3xl leading-normal font-open-sans font-bold tracking-wide">
            username
          </p>
          <%= if @editing_profile do %>
            <p class="my-0 ml-auto underline cursor-pointer" phx-click="cancel" phx-target={@myself}>
              cancel
            </p>
          <% else %>
            <p class="my-0 ml-auto underline cursor-pointer" phx-click="edit" phx-target={@myself}>
              edit
            </p>
      <.link
        href={Routes.google_auth_path(@socket, :logout)}
        method="post"
        class="my-0 ml-4 underline text-black hover:text-black"
      >
        log out
      </.link>
          <% end %>
        </div>
        <%= if @editing_profile do %>
          <.form for={@form} phx-submit="save" phx-target={@myself} class="mb-0">
            <.input
              field={@form[:username]}
              type="text"
              value={@user.username}
              class="!w-full block font-open-sans text-3xl tracking-wide"
            />
            <.button
              type="submit"
              class="text-nd-yellow bg-nd-pink hover:bg-nd-pink focus:bg-nd-pink border-0 mb-0 w-full"
            >
              Save
            </.button>
          </.form>
        <% else %>
          <p class="m-0 w-72 tracking-wide truncate text-3xl font-open-sans tracking-wide">
            <%= @user.username %>
          </p>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:editing_profile, false)
     |> assign(:form, to_form(%{}, as: :user))}
  end

  @impl true
  def handle_event("edit", _, socket) do
    form_data = %{"username" => socket.assigns.user.username}
    {:noreply,
     socket
     |> assign(:editing_profile, true)
     |> assign(:form, to_form(form_data, as: :user))}
  end

  def handle_event("cancel", _, socket) do
    {:noreply, assign(socket, :editing_profile, false)}
  end

  def handle_event("save", %{"user" => attrs}, socket) do
    case ClassicClips.Timeline.update_user(socket.assigns.user, attrs) do
      {:ok, user} ->
        {:noreply, assign(socket, :user, user) |> assign(:editing_profile, false)}

      _ ->
        {:noreply, socket}
    end
  end
end
