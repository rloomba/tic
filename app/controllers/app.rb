require 'sinatra'
require 'json'
require 'erb'

enable :sessions

class Board

  attr_accessor :board

  def initialize
    @board = Array.new(9)
    @win = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8], [0,4,8],[2,4,6]]
  end

  def update_board(position, player)
    puts "Player: #{player} Position: #{position}"
    if player == "human"
      board[position] = "X"
    else
      board[position] = "O"
    end
  end

  def game_over?
    a = false
    return true if @board.include?(nil) == false
    @win.each do |x|
      if @board[x[0]] == @board[x[1]] && @board[x[1]] == @board[x[2]]
        return true if @board[x[0]] != nil && @board[x[1]] != nil && @board[x[2]] != nil
      end
    end
    false
  end

  def winner
    @win.each do |x|
      if @board[x[0]] == @board[x[1]] && @board[x[1]] == @board[x[2]]
        if @board[x[0]] != nil && @board[x[1]] != nil && @board[x[2]] != nil
          return "Player wins!" if @board[x[0]] == "X"
          return "Computer wins!" if @board[x[1]] == "O"
        end
      end
    end
    "Tie Game"
  end

  def computer_move
    @win.each_with_index do |x|
      if @board[x[1]] == "O" && @board[x[2]] == "O"
        return x[0] unless @board[x[0]] != nil
      end
      if @board[x[0]] == "O" && @board[x[2]] == "O"
        return x[1] unless @board[x[1]] != nil
      end
      if @board[x[0]] == "O" && @board[x[1]] == "O"
        return x[2]  unless @board[x[2]] != nil
      end
    end
    @win.each_with_index do |x|
      if @board[x[1]] == "X" && @board[x[2]] == "X"
        return x[0] unless @board[x[0]] != nil
      end
      if @board[x[0]] == "X" && @board[x[2]] == "X"
        return x[1] unless @board[x[1]] != nil
      end
      if @board[x[0]] == "X" && @board[x[1]] == "X"
        return x[2]  unless @board[x[2]] != nil
      end
    end
    if @board[2] == "X" && @board[6] == "X"
      return 1 if @board[1] == nil
    end
    if @board[5] == "X" && @board[7] == "X"
      return 8 if @board[8] == nil
    end
    if @board[5] == "X" && @board[1] == "X"
      return 2 if @board[2] == nil
    end
    if @board[3] == "X" && @board[7] == "X"
      return 6 if @board[6] == nil
    end
    if @board[1] == "X" && @board[3] == "X"
      return 0 if @board[0] == nil
    end
    0.upto(8) do |num|
      return 2 if @board[4] == "X" && @board[2] == nil
      return 4 unless @board[4] == "X" || @board[4] == "O"
      return num unless @board[num] == "X" || @board[num] == "O"
    end
  end

end

get '/' do
  session[:board] = Board.new
  puts "here1"
  erb :index
end

post '/game' do
  content_type :json
  @board = session[:board]
  @board.update_board(params[:human_position][1].to_i, "human")
  move = @board.computer_move
  @board.update_board(move, "computer") unless @board.game_over?
  position = "c" + move.to_s
  {:computer_position => position , :game_over => @board.game_over?, :winner => @board.winner}.to_json
end
