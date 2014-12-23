module Minesweeper
  MINE_MARK = 'X'

  class Board
    attr_accessor :height, :width

    def initialize(input)
      @_data = input.gsub(" ", "").split("\n")
      self.height = @_data.length
      self.width = @_data[0].length
    end

    def read(row, col)
      if row >= 0 && row < self.height && col >= 0 && col < self.width
        @_data[row][col]
      end
    end

    def slice(row1, col1, row2, col2)
      slice = []
      (row1..row2).each do |i|
        (col1..col2).each do |j|
          slice << read(i, j)
        end
      end

      slice
    end

    def conver_to_output
      output = ""
      self.each_cell do |cell|
        if cell.mine?
          output << cell.value
        else
          output << cell.count_surrounding_mines.to_s
        end

        output << (cell.last_in_row? ? "\n" : " ")
      end

      output
    end

    def each_cell
      (0...height).each do |row|
        (0...width).each do |col|
          yield Cell.new(self, row, col)
        end
      end
    end
  end

  class Cell
    attr_accessor :board, :row, :col

    def initialize(board, row, col)
      self.board = board
      self.row = row
      self.col = col
    end

    def value
      @value ||= self.board.read(self.row, self.col)
    end

    def mine?
      self.value == MINE_MARK
    end

    def last_in_row?
      self.col == self.board.width - 1
    end

    def count_surrounding_mines
      slice_of_board = self.board.slice(self.row-1, self.col-1, self.row+1, self.col+1)
      slice_of_board.count(MINE_MARK)
    end
  end
end

board = Board.new("BMC_TEST_INPUT_MAGIC")
puts board.conver_to_output