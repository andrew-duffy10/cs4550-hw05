defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  # Credit to Nat Tuck's 07 Lecture notes
  #https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/07-phoenix/notes.md
  @impl true
  def join("game:" <> _id, payload, socket) do
    if authorized?(payload) do
      game = Bulls.Game.new()
      socket = assign(socket, :game, game)
      view = Bulls.Game.view(game)
      {:ok, view, socket}
      end
  end

  @impl true
  def handle_in("guess", %{"numbers" => ll}, socket) do
    game0 = socket.assigns[:game]
    game1 = Bulls.Game.make_guess(game0, ll)
    socket = assign(socket, :game, game1)
    view = Bulls.Game.view(game1)
    {:reply, {:ok, view}, socket}
  end

   @impl true
  def handle_in("reset", _, socket) do
    game = Bulls.Game.new
    socket = assign(socket, :game, game)
    view = Bulls.Game.view(game)
    {:reply, {:ok, view}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
