#!/bin/env ruby

$stdout.sync = true

Token = Struct.new :type, :moves, :pos do
  def matches?(idx)
    return false if @catched

    moves.include?(idx)
  end

  def catched!
    self.pos = -1
    @catched = true
  end

  def free
    @catched = false
  end

  def to_s
    "#{type} (#{moves.join('|')})"
  end

  def fish?
    type == :fish
  end

  def boat?
    type == :boat
  end
end

START_POS_BOAT = 12
START_POS_FISH = [5, 5, 5, 5]
TOKENS = [
  Token.new(:fish, [1], START_POS_FISH),
  Token.new(:fish, [2], START_POS_FISH),
  Token.new(:fish, [3], START_POS_FISH),
  Token.new(:fish, [4], START_POS_FISH),
  Token.new(:boat, [5, 6], START_POS_BOAT),
]

def reset
  TOKENS.each_with_index do |t, idx|
    if t.fish?
      t.pos = START_POS_FISH[idx % 4]
      t.free
    end
    if t.boat?
      t.pos = START_POS_BOAT
      t.moves = [5,6]
    end
  end
end

def turn
  num = rand(1..6)
  token = TOKENS.find { _1.matches?(num) }
  new_pos = token.pos - 1 rescue binding.irb

  if ENV['DEBUG']
    puts "1d6 -> #{num} | #{token}"
    draw_board
    sleep 0.5
  end
  if token.fish?
    if new_pos < 0
      token = TOKENS.find do |t|
        next if t.boat?
        next if t.pos == 0

        t
      end
      return false if token.nil? # End of game
    end

    token.pos -= 1
  end

  if token.boat?
    if new_pos > 0
      token.pos -= 1
      TOKENS.each do |t|
        next if t.boat?
        if t.pos == new_pos
          token.moves += t.moves
          t.catched!
        end
      end
    else
      return false
    end
  end

  # End turn if the boat catched at least 3 fish
  return false if TOKENS.find(&:boat?).moves.size >= 5

  # End game if at least 3 fish reached the ocean
  return false if TOKENS.select(&:fish?).count { _1.pos == 0 } >= 3

  return true
end

def draw_board
  (0..START_POS_BOAT).each do |tile_idx|
    printf "%2d | ", tile_idx
    TOKENS.each do |t|
      next unless t.pos == tile_idx
      print t.to_s, ' | '
    end
    puts
  end
  puts '-' * 15
end

def new_game
  idx = 0
  while turn
    puts "Turn #{idx+=1}" if ENV['DEBUG']
  end

  if ENV['DEBUG']
    TOKENS.each do |t|
      print t, "\t| "
      puts t.pos < 0 ? :Catched : t.pos
    end
  end
  survived = TOKENS.count { |t| t.fish? && t.pos == 0 }
  catched = TOKENS.find(&:boat?).moves.size - 2

  unless survived >= 3 || catched >= 3 || survived + catched == 4
    return :invalid
  end

  return :draw if catched == survived
  return :fish if survived >= 3
  return :boat if catched >= 3
end


counter = Hash.new(0)
ARGV[0].to_i.times do
  reset
  result = new_game
  draw_board if ENV['DEBUG']
  binding.irb if result == :invalid
  counter[result] += 1
end
p counter
