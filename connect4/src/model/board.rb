
module Models
  class Board

    def initialize(rows, columns)
      pre_initialize(rows, columns)
      @row_size = rows.to_i
      @column_size = columns.to_i
      @board = Array.new(@column_size) { Array.new(@row_size) }
      invariant
    end

    attr_reader :row_size, :column_size

    def each(&block)
      invariant
      return to_enum :each unless block_given?

      @block.each do |column|
        column.each(&block)
      end
      invariant
    end

    def get(row, column)
      invariant
      pre_get(row, column)
      value = @board[column.to_i][row.to_i]
      invariant
      value
    end
    alias_method :[], :get

    def set(column, token)
      invariant
      pre_set(column, token)
      column = column.to_i
      token = token.to_sym
      @board[column][next_available_row(column)] = token
      post_set(column, token)
      invariant
    end
    alias_method :[]=, :set

    def win?(pattern)
      
    end

    def column_full?(column)
      invariant
      pre_column_full(column)
      value = !@board[column].last.nil?
      invariant
      value
    end

    private

    def next_available_row(column)
      @board[column].index { |x| x.nil? }
    end

    def pre_get(row, column)
      assert row.respond_to(:to_i) && column.respond_to(:to_i)
      raise IndexError unless (row.to_i.abs.between?(0, @row_size - 1)) && (column.to_i.abs.between?(0, @column_size - 1))
    end

    def pre_set(column, token)
      raise ColumnFullError if column_full?(column)
      assert token.respond_to :to_sym
    end

    def post_set(column, token)
      row = @board[column].select { |x| !x.nil? }.last
      assert row[column] == token
    end

    def pre_column_full(column)
      assert column.respond_to? :to_i
      assert column < @board.size
    end

    def pre_intialize(rows, columns)
      assert rows.respond_to(:to_i) && columns.respond_to(:to_i)
      rows, columns = rows.to_i, columns.to_i
      assert rows > 0 && columns > 0
    end

    def invariant
      assert @column_size > 0
      assert @row_size > 0
      assert @board.size == @column_size
      assert @board[0].size == @row_size
    end

    class ColumnFullError < StandardError; end
    class IndexError < StandardError; end

  end

end