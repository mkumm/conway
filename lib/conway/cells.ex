defmodule Conway.Cells do
  def start() do
    MapSet.new()
  end

  def add_cell(cells, frame, location) do
    MapSet.put(cells, {frame, location})
  end

  def kill_cell(frame, location, cells) do
    MapSet.delete(cells, {frame, location})
  end

  def population_from_square(square, cells) do
    {frame, {x, y}} = square

    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
    |> Enum.filter(fn {x, y} -> x > 0 and y > 0 end)
    |> Enum.map(fn p -> MapSet.member?(cells, {frame, p}) end)
    |> Enum.count(& &1)
  end
end
