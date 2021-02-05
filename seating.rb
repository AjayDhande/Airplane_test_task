
class SeatingArrangement
  attr_accessor :total_seats, :max_seats, :passengers_count, :count

  def initialize
    puts "Enter number of Passengers"
    @passengers_count = gets.chomp
    @total_seats = [[3,2],[4,3],[2,3],[3,4]]
    @allocated_seats = 0
    @max_seats = @total_seats.inject(0) { |sum, x| sum += x[0] * x[1] }
    @count = 0
  end

  def make_arragments
    if @passengers_count.to_i <= @max_seats
      @available_seats = @total_seats.each_with_object([]).with_index do |(arr, seats)|
        seats << (1..arr[1]).map { |x| Array.new(arr[0]) { 'S' } }
      end
      columns = @total_seats.each_with_object([]).with_index do |(arr, seats)|
        seats << arr.last
      end
      @max_columns = columns.inject(0){|sum,x| sum + x }
      assign_seats
    else
      p "Number of Passengers are more the available seats, can't allocate all!"
    end
  end

  def assign_seats
    aisle_seats
    window_seats
    center_seats
    @available_seats.each_with_index do |arr, p_index|     
      arr.each_with_index do |s_arr, index|
        val = index == (arr.size - 1) ? s_arr.inspect.gsub(',', '').gsub('"', '') : s_arr.inspect.gsub(',', '').gsub('"', '') + ''       
        print "#{val}" 
      end 
      print "*"  
    end
  end

  private
  def aisle_seats
    (0..(@max_columns - 1)).each_with_index do |ele, p_index|
      @count = 0
      @available_seats.each_with_object([]) do |element_arr|
        element_arr.each_with_object([]).with_index do |(initial_array, result_arr), index|
          if p_index == index 
            if @count == 0 
              (initial_array.to_a[-1] = @allocated_seats.to_i + 1); @allocated_seats += 1
            elsif index == element_arr.length - 1 || @count == (@available_seats.size - 1)
              ((initial_array.to_a[0] = @allocated_seats.to_i + 1); @allocated_seats += 1)
              ((initial_array.to_a[-1] = @allocated_seats.to_i + 1); @allocated_seats += 1) unless @count == (@available_seats.size - 1)
            else
              ((initial_array.to_a[0] = @allocated_seats.to_i + 1); @allocated_seats += 1) 
              ((initial_array.to_a[-1] = @allocated_seats.to_i + 1); @allocated_seats += 1) unless initial_array.size == 1
            end
          end
        end
        @count += 1
      end
    end
  end

  def window_seats
    (0..(@max_columns - 1)).each_with_index do |ele, p_index|
      @count = 0
      @available_seats.each_with_object([]) do |element_arr|
        element_arr.each_with_object([]).with_index do |(initial_array, result_arr), index|
          if p_index == index
            if @count == 0 || @count == (@available_seats.size - 1)
              @count == 0 ? ((initial_array.to_a[0] = @allocated_seats.to_i + 1); @allocated_seats += 1) : ((initial_array.to_a[-1] = @allocated_seats.to_i + 1); @allocated_seats += 1)
            end
          end
        end
        @count += 1
      end
    end
  end

  def center_seats
    (0..(@max_columns - 1)).each_with_index do |ele, p_index|
      @count = 0
      @available_seats.each_with_object([]) do |element_arr|
        i = 0
        element_arr.each_with_object([]) do |initial_array|
          if p_index == i
            initial_array.to_a.each_with_index do |seat, index|
              ((initial_array.to_a[index] = @allocated_seats.to_i + 1); @allocated_seats += 1) if seat == "S" && (@allocated_seats <= (@passengers_count.to_i - 1))
            end
          end
          i += 1
        end
      end
    end
  end
  
end

seating = SeatingArrangement.new
seating.make_arragments
