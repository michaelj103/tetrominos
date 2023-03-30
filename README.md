# tetrominos

A utility for solving tetromino puzzles like those found in the game The Talos Principle

The goal of the puzzles is to file a rectangulare grid with a set of provided "tetrominos". The solver runs a simple backtracking algorithm to try all possible placement combinations and prints the first solution that it finds.

## Simple Usage

To build-and-run, simply invoke `swift run tetrominos`

In the current version, the tool is interactive only and will ask for "Dimensions" and "Pieces". Dimensions takes the form of a string `AxB` where `A` and `B` are integers. Pieces should be a string of counts and piece names. The possible names are the letters I, J, L, O, S, Z, and T that resemble the 7 standard Tetris pieces. For example

```
$ swift run tetrominos                                              
Building for debugging...
Build complete! (0.09s)
Dimensions: 8x5
Pieces: 4I2L2J1S1Z
┌─┐┌───────┐┌──────────┐
│ ││ ┌─────┘└──────────┘
│ ││ │┌──────────┐┌─┐┌─┐
│ │└─┘└──────────┘│ ││ │
│ └──┐┌────┐┌─┐┌─┐│ ││ │
└────┘│ ┌──┘│ ││ ││ ││ │
┌─┐┌──┘ │┌──┘ ││ ││ ││ │
│ │└────┘│ ┌──┘│ ││ ││ │
│ └─────┐│ │┌──┘ ││ ││ │
└───────┘└─┘└────┘└─┘└─┘
```

## Building for Release

If you want to build a standalone executable with release optimizations, run

```
swift build -c release --show-bin-path
```
This will build a release binary and output the path to it. It can be executed directly
