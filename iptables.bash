#!/bin/bash

total_steps=11

echo "Iniciando configuración de tu firewall, por </SecuritySpider>🕷️"

for ((step = 1; step <= total_steps; step++)); do
    sleep 0.6
    progress=$((step * 100 / total_steps))
    echo -ne "Implementando reglas iptables: [$progress%] $(printf '🕷️%.0s' $(seq 1 $((progress / 10))))\r"
done

echo -e "El script ha implementado de manera satisfactoria las reglas."

# Permitir Tráfico Establecido y Relacionado
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT


# Permitir Tráfico Local
iptables -A INPUT -i lo -j ACCEPT

# Limitar Conexiones
iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 5 --connlimit-mask 32 -j DROP


# Proteger contra Escaneo de Puertos
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP


# Limitar ICMP
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Registrar y Auditar
iptables -A INPUT -j LOG --log-prefix "IPTABLES-DROP: " --log-level 7

# Guardar Reglas
sudo iptables-save > iptables_backup.rules

# Ver la lista de reglas iptables
echo -e "\nLista de reglas iptables:"
iptables -L -n

#Se han corregido muchas cosas, destacando que estas reglas estan orientadas a computadores, muy pronto llegara las reglas para servidores, un saludo colegas.
