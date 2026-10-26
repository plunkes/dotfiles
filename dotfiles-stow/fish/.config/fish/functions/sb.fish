function sb --description 'Source the local colcon workspace if in a ROS Jazzy environment'
    if test -f /opt/ros/jazzy/setup.bash
        if test -f install/setup.bash
            bass source install/setup.bash
            echo "Sourced local workspace. :D"
        else
            echo "Error: install/setup.bash not found :(. Did you run colcon build?"
        end
    else
        echo "Not in a ROS Jazzy environment. >:("
    end
end
