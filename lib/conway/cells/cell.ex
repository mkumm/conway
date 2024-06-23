defmodule Conway.Cells.Cell do

  alias __MODULE__

  defstruct location: {0, 0}, live: false, frame: 0

  def make_live(frame, location) do
    %Cell{location: location, frame: frame, live: true}
  end

  def make_dead(frame, location) do
    %Cell{location: location, frame: frame, live: false}
  end

end
