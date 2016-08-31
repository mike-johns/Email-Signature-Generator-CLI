class String
  @@color_options = [["red", 31], ["green", 32], ["yellow", 33], ["blue", 34],
  ["pink", 95], ["light_blue", 94], ["white", 97], ["light_grey", 37],
  ["black", 30]]

  def self.create_colors
    @@color_options.each do |color, code|
      send(:define_method, "#{color}") do
        "\e[#{code}m" + self + "\e[0m"
      end
    end
  end

  def self.colors
    output_string = "["
    x = 1
    @@color_options.each do |color, code|
      if x < @@color_options.length
        output_string << ":#{color}, "
        x = x + 1
      else
        output_string << ":#{color}]"
      end
    end
    puts output_string
  end

  def self.sample_colors
    response = <<-HEREDOC
    This is #{"red".red}
    This is #{"green".green}
    This is #{"yellow".yellow}
    This is #{"blue".blue}
    This is #{"pink".pink}
    This is #{"light_blue".light_blue}
    This is #{"white".white}
    This is #{"light_grey".light_grey}
    This is #{"black".black}
    HEREDOC
    puts response
  end
end

String.create_colors
