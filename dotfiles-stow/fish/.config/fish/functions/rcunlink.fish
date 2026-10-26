function rcunlink
    echo "🔒 Desativando o Tailscale local..."
    sudo tailscale down
    echo "✅ Rede desconectada com segurança."
end
