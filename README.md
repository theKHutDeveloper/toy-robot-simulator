# Toy Robot Simulator

A command-line simulation of a toy robot moving on a 5×5 table, written in plain Ruby with RSpec tests.

## Requirements

- Ruby 3.0 or newer (developed and tested with Ruby 4.0.1, as set in `.ruby-version`)
- Bundler

## Setup

```bash
bundle install
```

## Running the app

Commands are read from files or from standard input.

**From a file:**

```bash
bin/toy_robot spec/fixtures/scenario_c.txt
# => 3,3,NORTH
```

**Typing commands** (one per line, press Ctrl+D to finish):

```bash
bin/toy_robot
```

**Piping commands in:**

```bash
printf "MOVE\nPLACE 0,0,NORTH\nMOVE\nJUMP\nREPORT\n" | bin/toy_robot
# => 0,1,NORTH
```

If you get "Permission denied", run `chmod +x bin/toy_robot` once, or run it with `ruby bin/toy_robot ...`.

Input is read with Ruby's `ARGF`, which reads from any files given on the command line, or from standard input if there are none. If several files are given, they are treated as one continuous stream, so the same robot carries on from one file to the next.

## Running the tests

```bash
bundle exec rspec
```

The example scenarios from the brief are in `spec/fixtures/` and are run as part of the test suite.

## Approach

The app is split into four classes, each with one job:

- **`Table`** knows its size and answers one question: is this position on the table? It defaults to 5×5 but the size can be configured.
- **`Robot`** knows its position and direction, and can place itself, turn, move and report. It does not know about the table.
- **`CommandParser`** turns one line of text into a command (a hash), or returns `nil` if the line is invalid. It checks syntax only, not table rules, so `PLACE 7,7,NORTH` parses successfully and is rejected later.
- **`Simulator`** ties them together. For each line it parses the command, checks the table where needed, and tells the robot what to do. It returns the text for `REPORT` and `nil` for everything else.

A small script, `bin/toy_robot`, handles input and output, so the simulator knows nothing about files or the terminal. That also makes it easy to test with a plain array of strings.

## Design decisions

- **The robot doesn't know about the table.** This keeps the robot simple, independent of one particular surface, and easy to test on its own. The trade-off is that the robot can't stop itself being moved somewhere invalid, so the simulator enforces the table rules. Before a `MOVE`, it asks the robot for its `next_position`, checks it with the table, and only then moves the robot.
- **All coordination lives in the simulator.** Every dependency points from the simulator to the other classes, so `Robot` and `Table` depend on nothing and can be changed or tested on their own. If the robot held the table, a change to `Table` could affect both the robot and the simulator. The exception is the list of valid directions, which the parser also needs (see future improvements).
- **Turning uses an ordered list of directions.** `NORTH, EAST, SOUTH, WEST` are stored clockwise, so turning right is +1 and left is −1, with modulo to wrap around.
- **Movement uses a lookup table.** Each direction maps to a change in x and y (for example, EAST is `[1, 0]`), instead of a `case` statement.
- **The robot also rejects invalid directions**, in case anything gets past the parser. It ignores them rather than raising an error.
- **Invalid commands are ignored.** Malformed commands such as `MOVE 2,3` are rejected entirely rather than guessing what was meant.
- **Lowercase commands are accepted.** Spaces inside the `PLACE` arguments (for example, `PLACE 1, 2, NORTH`) are not.
- **Coordinates are converted with `Integer(value, 10, exception: false)`**, because `to_i` turns non-numbers into 0, and plain `Integer` treats a leading zero as octal.
- **`report` returns a string, and the caller prints it**, which keeps output separate from the robot's logic.
- **Commands are processed one line at a time**, so `REPORT` prints immediately when typing commands.

## Future improvements

- Extract a `Direction` module or value object as the single source of truth for directions, rotation and movement, so the robot and parser don't each need to know the list.
- Accept whitespace around the `PLACE` arguments, such as `PLACE 1, 2, NORTH`.
- Try the alternative design where the robot holds the table, so the "don't fall off" rule can't be bypassed. This would also make obstacles easier to add.
- Give each command its own class (the command pattern), so adding a command doesn't mean editing the parser and simulator.
- Allow the table size to be set from the command line.
- Support multiple robots.
- Give feedback on ignored commands. At the moment they are dropped silently, which makes debugging input harder.
- Decide whether invalid input reaching the robot should raise an error rather than being ignored.
- Optionally give each input file a fresh robot.
- Add RuboCop (and rubocop-rspec) to enforce a consistent code style, and run it alongside the tests. I left it out to keep the scope of this exercise focused on the design and tests.
