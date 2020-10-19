defmodule KeyboardLayoutTest do
  use ExUnit.Case

  alias KeyboardLayout.{Key, LED}

  # The following layout is defined in `config/config.exs`:
  #
  # keys: [
  #   %{id: :k1, x: 0, y: 0, opts: [led: :l1]},
  #   %{id: :k2, x: 2, y: 1.5, opts: [width: 1.5, height: 2, led: :l2]},
  #   %{id: :k3, x: 5, y: 0}
  # ]
  # leds: [
  #   %{id: :l1, x: 0, y: 0},
  #   %{id: :l2, x: 2, y: 1.5},
  #   %{id: :l3, x: 3, y: 3}
  # ]

  setup [:create_config_layout, :add_config_keys, :add_config_leds]

  describe "a layout" do
    test "can be loaded from the config", %{
      config_layout: config_layout
    } do
      assert KeyboardLayout.load_from_config() == config_layout
    end

    test "can be created with only keys" do
      keys = [Key.new(:k1, 0, 0)]

      assert KeyboardLayout.new(keys) == %KeyboardLayout{
               keys: keys,
               keys_by_leds: %{},
               leds: [],
               leds_by_keys: %{}
             }
    end

    test "can be created with keys and LEDs", %{
      config_keys: config_keys,
      config_layout: config_layout,
      config_leds: config_leds
    } do
      assert KeyboardLayout.new(config_keys, config_leds) == config_layout
    end
  end

  test "a list of keys can be obtained from a layout", %{
    config_keys: config_keys,
    config_layout: config_layout
  } do
    assert KeyboardLayout.keys(config_layout) == config_keys
    assert KeyboardLayout.keys(config_layout) == config_layout.keys
  end

  test "a list of leds can be obtained from a layout", %{
    config_layout: config_layout,
    config_leds: config_leds
  } do
    assert KeyboardLayout.leds(config_layout) == config_leds
    assert KeyboardLayout.leds(config_layout) == config_layout.leds
  end

  describe "led_for_key/2" do
    test "takes a layout and a key id and returns the corresponding LED", %{
      config_layout: config_layout,
      config_leds: config_leds
    } do
      led_for_k1 = Enum.find(config_leds, fn %{id: id} -> id == :l1 end)
      assert KeyboardLayout.led_for_key(config_layout, :k1) == led_for_k1
    end

    test "returns nil when a key has no LED", %{
      config_layout: config_layout
    } do
      led_for_k3 = nil
      assert KeyboardLayout.led_for_key(config_layout, :k3) == led_for_k3
    end
  end

  describe "key_for_led/2" do
    test "takes a layout and a LED id and returns the corresponding key", %{
      config_keys: config_keys,
      config_layout: config_layout
    } do
      key_for_l1 = Enum.find(config_keys, fn %{led: led} -> led == :l1 end)
      assert KeyboardLayout.key_for_led(config_layout, :l1) == key_for_l1
    end

    test "returns nil when an LED is not assigned to a key", %{
      config_layout: config_layout
    } do
      key_for_l3 = nil
      assert KeyboardLayout.key_for_led(config_layout, :l3) == key_for_l3
    end
  end

  defp add_config_keys(%{config_layout: config_layout}) do
    [config_keys: config_layout.keys]
  end

  defp add_config_leds(%{config_layout: config_layout}) do
    [config_leds: config_layout.leds]
  end

  defp create_config_layout(_context) do
    config_layout = %KeyboardLayout{
      keys: [
        %Key{height: 1, id: :k1, led: :l1, width: 1, x: 0, y: 0},
        %Key{height: 2, id: :k2, led: :l2, width: 1.5, x: 2, y: 1.5},
        %Key{height: 1, id: :k3, led: nil, width: 1, x: 5, y: 0}
      ],
      keys_by_leds: %{
        l1: %Key{height: 1, id: :k1, led: :l1, width: 1, x: 0, y: 0},
        l2: %Key{height: 2, id: :k2, led: :l2, width: 1.5, x: 2, y: 1.5}
      },
      leds: [
        %LED{id: :l1, x: 0, y: 0},
        %LED{id: :l2, x: 2, y: 1.5},
        %LED{id: :l3, x: 3, y: 3}
      ],
      leds_by_keys: %{
        k1: %LED{id: :l1, x: 0, y: 0},
        k2: %LED{id: :l2, x: 2, y: 1.5}
      }
    }

    [config_layout: config_layout]
  end
end
