set -gx VENV_HOME ~/progs/libs
set -gx EDITOR nvim
set -gx VISUAL nvim
fish_add_path ~/.local/bin ~/.cargo/bin ~/go/bin ~/.npm-global/bin

# Machine-only vars, aliases and functions go in conf.d/local.fish — not tracked by git.

if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Direnv + Zoxide
    command -v direnv &>/dev/null && direnv hook fish | source
    command -v zoxide &>/dev/null && zoxide init fish --cmd cd | source

    # Better ls
    alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    abbr lg lazygit
    abbr y yazi
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr l ls
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    alias rosjazzy='distrobox enter ros-jazzy'

    complete -c venv -f -a "(ls $VENV_HOME)"
    complete -c rmvenv -f -a "(ls $VENV_HOME)"
    complete -c ros_build -f -a "(cat $HOME/.config/fish/ros_workspaces.txt 2>/dev/null | string split ' ')[1]" -d "ROS workspace"

    if test "$CONTAINER_ID" = ros-jazzy
        if test -f /opt/ros/jazzy/setup.bash
            bass source /opt/ros/jazzy/setup.bash
        end

        if command_exist register-python-argcomplete
            register-python-argcomplete --shell fish ros2 | source
        end
    end

    command -v fnm &>/dev/null && fnm env --use-on-cd --shell fish | source
end

