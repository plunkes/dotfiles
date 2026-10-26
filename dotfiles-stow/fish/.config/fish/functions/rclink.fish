function rclink
    echo "Ativando o Tailscale local..."
    sudo tailscale up

    echo "Aguardando sincronização da rede (3s)..."
    sleep 3

    echo "Conectando ao Servidor :)"
    ssh ros-server
end
