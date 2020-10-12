# FANCY COLOURING
class String
    def color(code)
        "\e[#{code}m#{self}\e[0m"
    end
    
    def red
        color(31)
    end
    
    def green
        color(32)
    end
    
    def yellow
        color(33)
    end
    
    def blue
        color(34)
    end
end