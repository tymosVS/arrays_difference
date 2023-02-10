a = [1,2,3,5,6,7,18]
b = [1,2,4,5,6,7,8,19]
c = [1,3,5,6,7,8,19]

@alphabet = (a + b + c).uniq

output_type = ARGV[0]

def colorize(value, color)
	case color
		when :red then "\e[31m" + value.to_s.center(@max_size) + "\e[0m"
		when :green then "\e[32m" + value.to_s.center(@max_size) + "\e[0m"
		when :yellow then "\e[33m" + value.to_s.center(@max_size) + "\e[0m"
		when :blue then "\e[34m" + value.to_s.center(@max_size) + "\e[0m"
		when :magenta then "\e[35m" + value.to_s.center(@max_size) + "\e[0m"
		when :cyan then "\e[36m" + value.to_s.center(@max_size) + "\e[0m"
		else value.to_s.center(@max_size)
	end
end

@element_colors = {
    '001': :blue,
    '010': :green,
    '100': :red,
    '011': :cyan,
    '101': :magenta,
    '110': :yellow,
    '111': :default
}

def in_a?(a, b, c, number)
    a.include?(number)
end

def in_b?(a, b, c, number)
    b.include?(number)
end

def in_c?(a, b, c, number)
    c.include?(number)
end

def in_all?(a, b, c, number)
    in_a?(a, b, c, number) && in_b?(a, b, c, number) && in_c?(a, b, c, number)
end

def decorate(a, b, c, output_type = 'compact')
    @alphabet.each do |number|
        next if output_type == 'compact' && in_all?(a, b, c, number)

        printed_line = [number, nil, nil, nil]
        color_code = 0

        if in_a?(a, b, c, number)
            color_code += 4
            printed_line[1] = number
        end
        if in_b?(a, b, c, number)
            color_code += 2
            printed_line[2] = number
        end
        if in_c?(a, b, c, number)
            color_code += 1
            printed_line[3] = number
        end

        printed_line[0] = colorize(number, @element_colors[color_code.to_s(2).rjust(3, '0').to_sym])
        write_line(printed_line)
    end
end

@max_size = @alphabet.max.size + 10
@columns = ["Elements" , "in a", "in b", "in c"]

def write_header
    write_divider
    puts "| #{ @columns.map { |g| g.center(@max_size) }.join(' | ') } |"
    write_divider
end

def write_divider
    puts "+-#{ @columns.map { |g| "-"*@max_size }.join("-+-") }-+"
end

def write_line(array)
    str = array.map { |k| k.to_s.center(@max_size) }.join(" | ")
    puts "| #{str} |"
    write_divider
end

write_header
decorate(a, b, c, output_type)
