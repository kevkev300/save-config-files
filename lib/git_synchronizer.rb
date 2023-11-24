# frozen_string_literal: true

class GitSynchronizer
  attr_reader :copy_location

  def initialize(copy_location:)
    @copy_location = copy_location
  end

  def pull
    puts 'Pulling from remote...'
    Dir.chdir(expended_path) do
      `git pull origin main`
    end
  end

  def push
    puts 'Pushing to remote...'
    current_time = Time.now.utc.strftime('%Y-%m-%d %H:%M:%S %Z')
    Dir.chdir(expended_path) do
      `git add .`
      `git commit -m "Syncronize local files with remote #{current_time}"`
      `git push origin main`
    end
  end

  private

  def expended_path = File.expand_path(copy_location)
end
