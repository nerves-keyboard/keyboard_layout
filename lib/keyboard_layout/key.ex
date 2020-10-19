defmodule KeyboardLayout.Key do
  @moduledoc """
  Describes a physical key and its location. Width and height are specified in
  relative units, so a key with a width of `2` will be twice as wide as `1`, and
  a height of `1.5` will be half the height of a key with a height of `3`.
  """

  alias KeyboardLayout.LED

  @typedoc """
  An atom used as a unique key identifier
  """
  @type id :: atom

  @typedoc """
  A key struct with an `id`, `x` and `y` positions, a `width`, a `height`, and
  an `led`.
  """
  @type t :: %__MODULE__{
          id: id,
          x: number,
          y: number,
          width: number,
          height: number,
          led: LED.id()
        }
  defstruct [:id, :x, :y, :width, :height, :led]

  @doc """
  Returns a new [`key`](`t:KeyboardLayout.Key.t/0`). The keyword list keys
  `width`, `height`, and `led` are optional parameters.
  """
  @spec new(
          id :: id,
          x :: number,
          y :: number,
          opts :: [width: number, height: number, led: LED.id()]
        ) :: t
  def new(id, x, y, opts \\ []) do
    %__MODULE__{
      id: id,
      x: x,
      y: y,
      width: Keyword.get(opts, :width, 1),
      height: Keyword.get(opts, :height, 1),
      led: Keyword.get(opts, :led)
    }
  end
end
