function arduino_setup --description "Detect a board and install the dependencies needed"
    set board_info (arduino-cli board list | grep "tty" | awk '{print $1, $7}')

    if test -z "$board_info"
        echo "No board found :("
        return 1
    end

    set port (echo $board_info | awk '{print $1}')
    set fqbn (echo $board_info | awk '{print $2}')

    echo "Detected $fqbn on $port :)"

    arduino-cli core install (echo $fqbn | cut -d: -f1,2)

    echo $fqbn >.arduino_fqbn
    echo $port >.arduino_port
end
