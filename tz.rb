require 'tty-prompt'
require 'json'


class TimezoneCLI
  def initialize
    @options = Hash.new
    map_timezones
    select_target_region
    select_target_subregion
    change_timezone
  end

  def change_timezone
    command = @target_subregion.empty? ? @target_region : [@target_region, @target_subregion].join('/')
    command_result = `sudo systemsetup -settimezone #{command} 2>&-`
    puts command_result
  end

  def select_target_subregion
    choices = @options[@target_region].flat_map { |e| e.join('/') }
    @target_subregion = TTY::Prompt.new.select("Select subregion:", choices, per_page: 20)
  end

  def select_target_region
    @target_region = TTY::Prompt.new.select("Select region:", @options.keys, per_page: 15)
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
