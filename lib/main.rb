# frozen_string_literal: true

require_relative 'copier'
require_relative 'first_run_assistant'
require_relative 'git_syncronizer'

class Main
  attr_reader :copier, :first_run_assistant, :git_syncronizer

  def initialize
    @copier = Copier.new
    @path = File.expand_path(__FILE__).gsub(Dir.home, '~')
    @first_run_assistant = FirstRunAssistant.new(copy_location: @copier.copy_location, main_path: @path)
    @git_syncronizer = GitSyncronizer.new(copy_location: @copier.copy_location)
  end

  def call
    puts 'Saving config files...'

    first_run_assistant.call if first_run_assistant.first_run?

    git_syncronizer.pull
    copier.copy
    git_syncronizer.push
  end

  def setup
    puts 'Setting up save-config-files...'
    first_run_assistant.call
    call
  end
end

Main.new.call
