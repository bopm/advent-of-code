defmodule Router do
  def parse(input) do
    input
    |> Kino.Input.read()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {str, y} ->
      Enum.map(Enum.with_index(String.split(str, "", trim: true)), fn {str, x} ->
        distance = if str == "S", do: 0, else: nil
        %{value: str, coords: [x, y], distance: distance}
      end)
    end)
  end

  def replace_tile(sketch, tile) do
    [x, y] = Map.get(tile, :coords)
    List.replace_at(sketch, y, List.replace_at(Enum.at(sketch, y), x, tile))
  end

  def coords(%{value: "S"}, coords: [x, y], distance: distance} = _tile, _max_x, _max_y) do
    [0, 0]
  end

  defcoords(%{value: "."}, coords: [x, y], distance: distance} = _tile, _max_x, _max_y) do
    [nil, nil]
  end

  def coords(%{value: "-", coords: [x, y], distance: distance} = _tile, max_x, _max_y) do
    if x == max_x || x == 0 do
      [nil, nil]
    else
      [[x - 1, y], [x + 1, y]]
    end
  end

  def coords(%{value: "|", coords: [x, y], distance: distance} = tile, _max_x, max_y) do
    if y == max_y || y == 0 do
      [nil, nil]
    else
      [[x, y - 1], [x, y + 1]]
    end
  end

  def coords(%{value: "L", coords: [x, y], distance: distance} = tile, max_x, _max_y) do
    if y == 0 || x == max_x do
      [nil, nil]
    else
      [[x, y - 1], [x + 1, y]]
    end
  end

  def coords(%{value: "J", coords: [x, y], distance: distance} = tile, _max_x, _max_y) do
    if y == 0 || x == 0 do
      [nil, nil]
    else
      [[x, y - 1], [x - 1, y]]
    end
  end

  def coords(%{value: "7", coords: [x, y], distance: distance} = tile, _max_x, max_y) do
    if y == max_y || x == 0 do
      [nil, nil]
    else
      [[x - 1, y], [x, y + 1]]
    end
  end

  def coords(%{value: "F", coords: [x, y], distance: distance} = tile, max_x, max_y) do
    if y == max_y || x == max_x do
      [nil, nil]
    else
      [[x + 1, y], [x, y + 1]]
    end
  end

  def walk(
        sketch,
        x, y
      ) do
    tile = Enum.at(sketch, y) |> Enum.at(x)
    [start, finish] = coords(tile, Enum.count(sketch) - 1, Enum.count(Enum.at(sketch, 0)) - 1)
    if Map.get(tile, :distance) != nil || start == nil do
      sketch
    else
      min = if start == 0 do
        updated = sketch
        |> walk(start)
        |> walk(finish)

        directions = [
          Map.get(Enum.at(Enum.at(updated, Enum.at(start, 1)), Enum.at(start, 0)), :distance),
          Map.get(Enum.at(Enum.at(updated, Enum.at(finish, 1)), Enum.at(finish, 0)), :distance)
        ]

        Enum.min(directions)
      else
        0
      end

      if Enum.member?(directions, nil),
        do: updated,
        else: replace_tile(updated, %{tile | distance: min + 1})
    end
  end

  def p1(input) do
    sketch = parse(input)

    Enum.reduce(List.flatten(sketch), sketch, fn tile, acc ->
      walk(tile, Map.get(tile, :coords), acc)
    end)

    # |> List.flatten
    # |> Enum.reject(fn v -> v == nil end)
    # |> Enum.max
  end
end
