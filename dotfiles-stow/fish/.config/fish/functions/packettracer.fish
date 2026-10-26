function packettracer --description "Open Cisco Packet Tracer through Xwayland"
    env QT_QPA_PLATFORM=xcb /usr/lib/packettracer/packettracer.AppImage $argv
end
