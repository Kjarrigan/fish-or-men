# Math

I own a game for children (age 3-7) which had some rules that seemed pretty unfair. You basically have to bet if
team fish or team boat wins. And most of the time with the default rules the boat wins or maybe you get a draw.
So I tweaked the rules a bit and it was more "even".

But now I want to re-build the game in Godot as some Game Programming practice and I wondered how exactly the
default probabilities are for either team to win and what to do make it fair for my version of the game.

## Base Rules

The board consists of 13 fields.
- 1 Ocean tile (the goal for Team Fish)
- 11 Water tiles (with the middle tile being the start point for the fish)
- 1 Boat tile

Each turn you roll a `d6`. Depending on it's color one of the 4 fished go 1 tile to the left or
the boat. The boat start with two colored fishermen so it has a 2/6 change to move a tile.

If the boat reaches a tile with a fish - the fish is catched (thrown into the boat) AND now the fishs
color counts toward the boat! So the more fish it catches the likelier it'll move further.

If a fish reached the ocean tile it is safe. If you roll a color that is already safe you can chose
what fish you want to move instead. That's basically the only "strategic" element. Otherwise its
just dice rolling until the board is resolved and you see the outcome.

Intuitively we always moved the fish fartest to the right, to save it from the boat (at least one
more turn) but how are the odds if e.g. you use a random fish or the fish closest to the ocean.

## Run the calculation

If you have a ruby installed just do `ruby scores.rb HOW_MANY_GAMES_SHALL_BE_PLAYED`
setting the environment_variable `DEBUG=1` you can watch the game (best to use with a small number of
rounds)

Alternativly if you have no ruby you can also run it via docker like that

```
docker build . -t fish
docker run -e DEBUG=1 fish 1
docker run fish 1000000
```

Each of the following tests was done with 100_000 games to determine the probabilities:

### Test-1 : Original - 13 tiles, 4xfish@7, boat@13

This confirms my "feeling" when playing the original - that it was "heavily" favored towards the
boat.

```ruby
{:boat=>53464, :fish=>34000, :draw=>12536}
```

### Test-2 : More Tiles - 14 tiles, 4xfish@7, boat@14

This evens out the odds quite a bit BUT it won't work for the physical game as I do not have more tiles
int the box (I could handcraft one with my children which would probably be some fun, but I would like
to find a solution that works with the base game)

```ruby
{:boat=>42317, :fish=>44961, :draw=>12722}
```

### Test-3 : Changed Starting Positions: 13 tiles, 2xfish@6, 2xfish@7, boat@13

Not too bad either. Slightly higher draws but pretty close chances for fish and boat. I think this will
for now be my setup for the physical game because it's super easy to setup.

```ruby
{:boat=>40692, :fish=>45417, :draw=>13891}
```

### Test-4: Changed Starting Positions, 13 tiles, 4xfish@6, boat@13

This is only listed here because that what my original attempt was to tweak the chances for the fishes
when playing the game. But it's heavily in favor of one team (this team the fishes).

```ruby
{:boat=>30469, :fish=>57329, :draw=>12202}
```
