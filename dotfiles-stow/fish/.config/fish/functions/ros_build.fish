function ros_build -d "Compiles and sources a ros workspace :D"
    set -l ws_name $argv[1]
    set -l config_file "$HOME/.config/fish/ros_workspaces.txt"

    if test -z "$ws_name"
        echo "Error: insert a valid workspace name"
        return 1
    end

    set -l ws_path (grep "^$ws_name " "$config_file" | awk '{print $2}')

    if test -z "$ws_path"
        echo "Error: Workspace '$ws_name' not found in $config_file"
        echo "Try inserting it in $config_file :)"
        return 1
    end

    if cd "$HOME/$ws_path"
        if colcon build --symlink-install
            echo "Colcon builded with sucess! :D"

            if test -f "install/setup.bash"
                bass source install/setup.bash
                echo "Workspace sourced"
            end
        else
            echo "Something went wrong with colcon :("
            return 1
        end
    else
        echo "The path informed for this workspace does not exist :O"
        echo "Debug: Tentando acessar o caminho |$ws_path|"
        return 1
    end
end
