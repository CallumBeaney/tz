require 'tty-prompt'
require 'json'


class TimezoneCLI
  def initialize
    @options = Hash.new
    map_timezones
    select_input_type
    make_selection
    change_timezone
  end

  def change_timezone
    command = @target_subregion.nil? || @target_subregion.empty? ? @target_region : [@target_region, @target_subregion].join('/')
    command_result = `sudo systemsetup -settimezone #{command} 2>&-`
    puts command_result
  end

  def select_target_subregion
    choices = @options[@target_region].flat_map { |e| e.join('/') }
    @target_subregion = TTY::Prompt.new.select("Select subregion:", choices, per_page: 20)
  end

  def select_target_region
    @target_region = TTY::Prompt.new.select("Select region:", @options.keys, per_page: 15)
    puts "Selected region: #{@target_region}" # Debug statement to check the selected region
  end

  def make_selection
    case @input_type
    when "Recent"
      # Add logic for "Recent" option
      # Will need to remember recent selections
      puts "`Recent` functionality not implemented yet."
      select_target_region
      select_target_subregion unless @target_region == "GMT"
    when "By Region"
      select_target_region
      select_target_subregion unless @target_region == "GMT"
    when "Search A-Z"
      # Add logic for "Search A-Z" option
      # maybe .map to filter timezones by letters entered
      puts "`Search A-Z` functionality not implemented yet."
      select_target_region
      select_target_subregion unless @target_region == "GMT"
    else
      puts "Invalid input type selected."
    end
  end

  def select_input_type
    @input_type = TTY::Prompt.new.select("Select input type:", ["Recent", "By Region", "Search A-Z"], per_page: 3)
  end

  def map_timezones
    command_result = `sudo systemsetup listtimezones`

    parsed_lines = command_result.split(/\n/)
    parsed_lines.slice!(0) # remove "Time Zones:"

    parsed_lines.each do |line|
      split = line.split('/') # [" America", "Argentina", "Buenos_Aires"] 
      region = split.first.strip # "America"

      @options[region] = [] unless @options.has_key?(region) 

      subregion = split[1, split.length]
      @options[region].push(subregion)
    end

  end
end

TimezoneCLI.new
