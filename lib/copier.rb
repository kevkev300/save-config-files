# frozen_string_literal: true

require 'yaml'

class Copier
  FILES_FILE = 'file_paths.yml'
  COPY_DIR = 'coding_config_files'

  attr_reader :copy_location

  def initialize
    @copy_location = File.expand_path(__FILE__)
                         .gsub(Dir.home, '~')
                         .gsub('save-config-files/lib/copier.rb', COPY_DIR)
  end

  def copy
    files.each do |file|
      puts file
      `cp ~/#{file} #{copy_location}`
    end
  end

  private

  def files
    file_path = File.join(File.dirname(__FILE__), FILES_FILE)
    YAML.load_file(file_path)
  end
end
