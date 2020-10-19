defmodule KeyboardLayout do
  @moduledoc """
  Describes a keyboard layout.

  The layout can be created dynamically, or it can be predefined in the `Config`
  for the application.

  Example of a layout defined in `Config`:

      import Config

      config :keyboard_layout,
        layout: [
          leds: [
            %{id: :l1, x: 0, y: 0},
            %{id: :l2, x: 2, y: 1.5},
            %{id: :l3, x: 3, y: 3}
          ],
          keys: [
            %{id: :k1, x: 0, y: 0, opts: [led: :l1]},
            %{id: :k2, x: 2, y: 1.5, opts: [width: 1.5, height: 2, led: :l2]},
            %{id: :k3, x: 5, y: 0}
          ]
        ]
  """

  alias __MODULE__.{Key, LED}

  @typedoc """
  A keyboard layout consisting of [keys](`t:KeyboardLayout.Key.t/0`) and optional
  [LEDs](`t:KeyboardLayout.LED.t/0`).
  """
  @type t :: %__MODULE__{
          keys: [Key.t()],
          leds: [LED.t()],
          leds_by_keys: %{Key.id() => LED.t()},
          keys_by_leds: %{LED.id() => Key.t()}
        }
  defstruct [:keys, :leds, :leds_by_keys, :keys_by_leds]

  @doc """
  Creates a new [KeyboardLayout](`t:KeyboardLayout.t/0`) from a list of keys and
  LEDs. LEDs are optional.

  Example:

      iex> keys = [KeyboardLayout.Key.new(:k1, 0, 0, led: :l1)]
      [%KeyboardLayout.Key{height: 1, id: :k1, led: :l1, width: 1, x: 0, y: 0}]
      iex> leds = [KeyboardLayout.LED.new(:l1, 0, 0)]
      [%KeyboardLayout.LED{id: :l1, x: 0, y: 0}]
      iex> KeyboardLayout.new(keys, leds)
      %KeyboardLayout{
        keys: [
          %KeyboardLayout.Key{height: 1, id: :k1, led: :l1, width: 1, x: 0, y: 0}
        ],
        keys_by_leds: %{
          l1: %KeyboardLayout.Key{height: 1, id: :k1, led: :l1, width: 1, x: 0, y: 0}
        },
        leds: [
          %KeyboardLayout.LED{id: :l1, x: 0, y: 0}
        ],
        leds_by_keys: %{
          k1: %KeyboardLayout.LED{id: :l1, x: 0, y: 0}
        }
      }
  """
  @spec new(keys :: [Key.t()], leds :: [LED.t()]) :: t
  def new(keys, leds \\ []) do
    leds_map = Map.new(leds, &{&1.id, &1})

    leds_by_keys =
      keys
      |> Enum.filter(& &1.led)
      |> Map.new(&{&1.id, Map.fetch!(leds_map, &1.led)})

    keys_by_leds =
      keys
      |> Enum.filter(& &1.led)
      |> Map.new(&{&1.led, &1})

    %__MODULE__{
      keys: keys,
      leds: leds,
      leds_by_keys: leds_by_keys,
      keys_by_leds: keys_by_leds
    }
  end

  @doc """
  Returns a list of [keys](`t:KeyboardLayout.Key.t/0`) from the provided [layout](`t:KeyboardLayout.t/0`)
  """
  @spec keys(layout :: t) :: [Key.t()]
  def keys(layout), do: layout.keys

  @doc """
  Returns a list of [leds](`t:KeyboardLayout.LED.t/0`) from the provided [layout](`t:KeyboardLayout.t/0`)
  """
  @spec leds(layout :: t) :: [LED.t()]
  def leds(layout), do: layout.leds

  @doc """
  Returns the corresponding [LED](`t:KeyboardLayout.LED.t/0`) from the provided [layout](`t:KeyboardLayout.t/0`)
  and [key id](`t:KeyboardLayout.Key.id/0`).

  Returns `nil` if the LED does not belong to a key.
  """
  @spec led_for_key(layout :: t, Key.id()) :: LED.t() | nil
  def led_for_key(%__MODULE__{} = layout, key_id) when is_atom(key_id),
    do: Map.get(layout.leds_by_keys, key_id)

  @doc """
  Returns the corresponding [key](`t:KeyboardLayout.Key.t/0`) from the provided [layout](`t:KeyboardLayout.t/0`)
  and [LED id](`t:KeyboardLayout.LED.id/0`).

  Returns `nil` if the key has no LED.
  """
  @spec key_for_led(layout :: t, LED.id()) :: Key.t() | nil
  def key_for_led(%__MODULE__{} = layout, led_id) when is_atom(led_id),
    do: Map.get(layout.keys_by_leds, led_id)

  @doc """
  Returns the [layout](`t:KeyboardLayout.t/0`) defined in the `Config` of the application
  """
  @spec load_from_config() :: t
  def load_from_config do
    env_layout =
      case Application.get_env(:keyboard_layout, :layout) do
        nil -> raise "A layout must be defined for the application to function"
        layout -> layout
      end

    keys = build_keys(Keyword.get(env_layout, :keys, []))
    leds = build_leds(Keyword.get(env_layout, :leds, []))
    new(keys, leds)
  end

  @spec build_leds([map]) :: [LED.t()]
  defp build_leds(led_list) do
    led_list
    |> Enum.map(fn %{id: id, x: x, y: y} ->
      LED.new(id, x, y)
    end)
  end

  @spec build_keys([map]) :: [Key.t()]
  defp build_keys(key_list) do
    key_list
    |> Enum.map(fn
      %{id: id, x: x, y: y, opts: opts} ->
        Key.new(id, x, y, opts)

      %{id: id, x: x, y: y} ->
        Key.new(id, x, y)
    end)
  end
end
