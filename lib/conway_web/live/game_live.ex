defmodule ConwayWeb.GameController do
  use ConwayWeb, :live_view

  alias Conway.Cells

  def mount(_params, _session, socket) do
    frame = 0
    board =
      Cells.start()
      |> Cells.add_cell(frame, {0,0})
      |> Cells.add_cell(frame, {0,1})
      |> Cells.add_cell(frame, {1,1})

    socket =
      socket
      |> assign(:board, board)

    send(self(), {:next_frame, 0, board})

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Game of Life</h1>

    <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <!-- Simple rectangle -->
      <rect height="100" width="100" fill="black" />
      <%= for {_,{x,y}} <- @board do %>
        <rect x={x} y={y} width="1" height="1", fill="yellow" />
      <% end %>


      <!-- Rounded corner rectangle -->

    </svg>
    """
  end

  def handle_info({:next_frame, frame, cells}, socket) do
    next_frame(frame, cells)
    |> IO.inspect()
    {:noreply, socket}
  end

  def next_frame(frame, cells) do
    board = for x <- 0..9, y <- 0..9, do: {frame, {x, y}}

    populations = Enum.map(board, fn cell -> {x, y, Cells.population_from_cell(cell, cells)} end)

    Enum.each(populations)
  end
end
