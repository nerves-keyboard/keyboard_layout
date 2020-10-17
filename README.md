# KeyboardLayout

[![CI Status](https://github.com/nerves-keyboard/keyboard_layout/workflows/CI/badge.svg)](https://github.com/nerves-keyboard/keyboard_layout/actions)
[![codecov](https://codecov.io/gh/nerves-keyboard/keyboard_layout/branch/master/graph/badge.svg)](https://codecov.io/gh/nerves-keyboard/keyboard_layout)

KeyboardLayout is a Nerves Keyboard library for defining a layout of keys and
LEDs.

See [`config/config.exs`](./config/config.exs) for an example of how to define
a layout.

## Installation

The package can be installed by adding `keyboard_layout` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:keyboard_layout, github: "nerves-keyboard/keyboard_layout"}
  ]
end
```

## License

This library is licensed under the [MIT license](./LICENSE.md)
