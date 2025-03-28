require 'tty-prompt'
require 'json'

class TimezoneCLI
  RECENT_SELECTIONS_FILE = 'recent_selections.json'

  def initialize
    @options = Hash.new
    @recent_selections = read_recent_selections
    @recent_array_length = 10
    map_timezones
    select_input_type
    make_selection
    change_timezone
  end

  def read_recent_selections
    if File.exist?(RECENT_SELECTIONS_FILE)
      JSON.parse(File.read(RECENT_SELECTIONS_FILE))
    else
      [] # return empty array if file doesn't exist to avoid errors
    end
  end

  def write_recent_selection(region, subregion)
    formatted_selection = subregion.nil? || subregion.empty? ? region : "#{region}|#{subregion}"

    @recent_selections << formatted_selection
    @recent_selections.uniq! # remove duplicates from array
    @recent_selections.shift if @recent_selections.size > @recent_array_length
    File.write(RECENT_SELECTIONS_FILE, @recent_selections.to_json)
  end

  def change_timezone
    command = @target_subregion.nil? || @target_subregion.empty? ? @target_region : [@target_region, @target_subregion].join('/')
    command = command.gsub('|', '/') # substitute | with / from recent selections
    command_result = `sudo systemsetup -settimezone #{command} 2>&-`
    puts command_result # unless @input_type == "Automatic"
  end

  def select_target_subregion
    choices = @options[@target_region].flat_map { |e| e.join('/') }
    @target_subregion = TTY::Prompt.new.select("Select subregion:", choices, per_page: 25)
  end

  def select_target_region
    @target_region = TTY::Prompt.new.select("Select region:", @options.keys, per_page: 25)
  end

  def make_selection
    case @input_type
    when "Recent"
      if @recent_selections.empty?
        puts "No recent selections available."
        select_target_region
        select_target_subregion unless @target_region == "GMT"
      else
        display_selections = @recent_selections.map { |sel| sel.gsub('|', '/') }
        recent_selection = TTY::Prompt.new.select("Select recent selection:", display_selections, per_page: @recent_array_length)
        @target_region, @target_subregion = recent_selection.gsub('/', '|').split('|', 2)
      end
    when "By Region"
      select_target_region
      select_target_subregion unless @target_region == "GMT"
    # when "Automatic"
    #   # doesn't work yet, getting errors despite seemingly turning on right settings \_(ツ)_/
    #   system("sudo systemsetup -setusingnetworktime on")
    #   system("sudo systemsetup -setnetworktimeserver time.apple.com")
    #   puts "System clock set to update automatically using network time."
    else
      puts "Invalid input type selected."
    end

    write_recent_selection(@target_region, @target_subregion) # unless @input_type == "Automatic"
  end

  def select_input_type
    @input_type = TTY::Prompt.new.select("Select input type:", ["Recent", "By Region"], per_page: 2)
  end

  def make_selection
    case @input_type
    when "Recent"
      if @recent_selections.empty?
        puts "No recent selections available."
        select_target_region
        select_target_subregion unless @target_region == "GMT"
      else
        recent_selection = TTY::Prompt.new.select("Select recent selection:", @recent_selections, per_page: @recent_array_length)
        @target_region, @target_subregion = recent_selection.split('/')
      end
    when "By Region"
      select_target_region
      select_target_subregion unless @target_region == "GMT"
    else
      puts "Invalid input type selected."
    end

    write_recent_selection(@target_region, @target_subregion)
  end

  def select_input_type
    @input_type = TTY::Prompt.new.select("Select input type:", ["Recent", "By Region"], per_page: 2)
  end

  def map_timezones
    command_result = `sudo systemsetup listtimezones`

    parsed_lines = command_result.split(/\n/)
    parsed_lines.slice!(0) # remove "Time Zones:"

    parsed_lines.each do |line|
      split = line.split('/') # ["America", "Argentina", "Buenos_Aires"]
      region = split.first.strip # "America"

      @options[region] = [] unless @options.has_key?(region) 

      subregion = split[1, split.length]
      @options[region].push(subregion)
    end

  end
end

TimezoneCLI.new