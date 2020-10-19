defmodule KeyboardLayout.LED do
  @moduledoc """
  Describes a physical LED location.
  """

  @typedoc """
  An atom used as a unique LED identifier
  """
  @type id :: atom

  @typedoc """
  An LED struct with an `id`, an `x` position, and a `y` position.
  """
  @type t :: %__MODULE__{
          id: id,
          x: number,
          y: number
        }
  defstruct [:id, :x, :y]

  @doc """
  Returns a new (LED)(`t:KeyboardLayou.LED.t/0`).
  """
  @spec new(id :: id, x :: number, y :: number) :: t
  def new(id, x, y) do
    %__MODULE__{
      id: id,
      x: x,
      y: y
    }
  end
end
