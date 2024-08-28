## A simple tool to use automatic file synchronizer in ruby

### How does it work
1. clone the repo
2. within `lib/file_paths.yml` define the files you want to sync in regards to the HOME directory (`~`)
3. within this repo, run `ruby lib/main.rb`. On the first run this will set up everything and then runs the sync
   1. Repo setup
      1. it creates a git repo in `../` defined in `lib/copier.rb` under `COPY_DIR`. Feel free to change that name
      2. creates a private GitHub repo with the same name (`COPY_DIR`) for the GitHub profile that you have setup on your machine
   2. Automation Setup
      1. creates a script file `config_files_syncronizer.sh` in the HOME directory (automation does not work yet)
4. add the following to your shell file (e.g. `~/.zshrc`) to make the automation work:
   ```
   # sync files to github using save-config-files
   [[ -f "$HOME/config_files_syncronizer.sh" ]] && source "$HOME/config_files_syncronizer.sh"
   ```
5. The automation works like this: the combination of the script from 4. and the script file from 3.3.1 automatically runs the code within `lib/main.rb` once a day as soon as you open your terminal
6. The sync basically is just an upload sync. The files you define in `lib/file_paths.yml` will be copied to the `COPY_DIR` every time `lib/main.rb` runs (yes, you can always run `ruby lib/main.rb` and do not need to wait for the automation). Then, the copied files will be synced to the Github repository. And voila, you will never loose your config files again.
