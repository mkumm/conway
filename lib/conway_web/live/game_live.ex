defmodule ConwayWeb.GameController do
  @moduledoc """
    Any live cell with fewer than two live neighbours dies, as if by underpopulation.
    Any live cell with two or three live neighbours lives on to the next generation.
    Any live cell with more than three live neighbours dies, as if by overpopulation.
    Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  """
  use ConwayWeb, :live_view

  alias Conway.Cells

  def mount(_params, _session, socket) do
    frame = 0

    cells =
      Cells.start()
      |> Cells.add_cell(frame, {50, 50})
      |> Cells.add_cell(frame, {50, 51})
      |> Cells.add_cell(frame, {50, 52})
      |> Cells.add_cell(frame, {49, 51})
      |> Cells.add_cell(frame, {51, 52})

    socket =
      socket
      |> assign(:cells, cells)
      |> assign(:frame, 0)
      |> assign(:population, MapSet.size(cells))

    # send(self(), {:next_frame, 0, board})

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Game of Life</h1>
    <p>Generation: <%= @frame %>, Population: <%= @population %></p>
    <button
      phx-click="next_frame"
      class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
    >
      Next Frame
    </button>
    <button
      phx-click="start_play"
      class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
    >
      Start Play
    </button>

    <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <!-- Simple rectangle -->
      <rect height="100" width="100" fill="black" />
      <%= for {_,{x,y}} <- @cells do %>
        <rect x={x} y={y} width="1" height="1" , fill="yellow" />
      <% end %>
    </svg>
    """
  end

  def handle_info({"next_frame", continue}, socket) do
    cells = build_next_frame(socket.assigns.frame, socket.assigns.cells)

    socket =
      socket
      |> assign(:cells, cells)
      |> assign(:frame, socket.assigns.frame + 1)
      |> assign(:population, MapSet.size(cells))

    if continue, do: Process.send_after(self(), {"next_frame", true}, 100)
    {:noreply, socket}
  end

  def handle_event("next_frame", _, socket) do
    send(self(), {"next_frame", false})
    {:noreply, socket}
  end

  def handle_event("start_play", _, socket) do
    Process.send_after(self(), {"next_frame", true}, 500)
    {:noreply, socket}
  end

  def build_next_frame(frame, cells) do
    board = for x <- 0..99, y <- 0..99, do: {x, y}
    cells_start = cells

    new_cells =
      board
      |> Enum.map(fn {x, y} -> {x, y, Cells.population_from_square({frame, {x, y}}, cells)} end)
      |> Enum.reduce(Cells.start(), fn {x, y, count}, acc ->
        if count == 3,
          do: Cells.add_cell(acc, frame + 1, {x, y}),
          else: acc
      end)

    cells_start
    |> Enum.filter(fn {f, _} -> f == frame end)
    |> Enum.map(fn {_, {x, y}} -> {x, y, Cells.population_from_square({frame, {x, y}}, cells)} end)
    |> Enum.reduce(new_cells, fn {x, y, count}, acc ->
      if count in [2, 3],
        do: Cells.add_cell(acc, frame + 1, {x, y}),
        else: acc
    end)
  end
end
