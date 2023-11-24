# frozen_string_literal: true

class FirstRunAssistant
  attr_reader :copy_location, :main_path

  def initialize(copy_location:, main_path:)
    @copy_location = copy_location
    @main_path = main_path
  end

  def first_run?
    !(File.directory?(expended_path) && File.exist?(File.join(expended_path, '.git')))
  end

  def call
    create_git_repo
    create_shell_script
  end

  private

  def expended_path = File.expand_path(copy_location)

  def create_git_repo
    puts 'Creating git repo...'
    create_git_directory
    initializing_git_repo
  end

  def create_git_directory
    puts "Directory does not exist. Creating directory: #{copy_location}"
    @new = true
    `mkdir #{copy_location}`
  end

  def initializing_git_repo
    Dir.chdir(expended_path) do
      initialize_local_git_repo
      create_private_github_repo
    end
  end

  def initialize_local_git_repo
    puts "Initializing a new Git repository in #{copy_location} ..."
    `git init`
    `git symbolic-ref HEAD refs/heads/main`
  end

  def create_private_github_repo
    Dir.chdir(expended_path) do
      puts 'Creating private Github repo...'
      `gh repo create --private --source=. --remote=origin`
      `touch README.md`
      `echo "In this repo, I save my local config files" >> README.md`
      `git add .`
      `git commit -m "Initial commit"`
      `git push origin main`
    end
  end

  def create_shell_script
    puts 'Writing script to syncronize config files...'
    `touch ~/config_files_syncronizer.sh`
    `echo '#{script}' > ~/config_files_syncronizer.sh`
  end

  def script
    <<~HEREDOC
      # this script is used together with the ruby script in #{main_path}
      LAST_RUN_FILE=~/.last_ruby_script_run
      TODAY=$(date +%Y-%m-%d)
      if [ "$(cat $LAST_RUN_FILE 2>/dev/null)" != "$TODAY" ]; then
        ruby #{main_path}
        echo $TODAY > $LAST_RUN_FILE
      fi
    HEREDOC
  end
end
