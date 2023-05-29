# informacao-do-sistema
Teste

### test:

      sudo apt

-----------



      #!/bin/sh

      # Caminho para os executáveis
      UPTIME_CMD="/usr/bin/uptime"
      DF_CMD="/bin/df"
      FREE_CMD="/usr/bin/free"
      PS_CMD="/bin/ps"
      WHO_CMD="/usr/bin/who"
      IFCONFIG_CMD="/sbin/ifconfig"
      LSB_RELEASE_CMD="/usr/bin/lsb_release"

      # Obtém as informações necessárias
      SYSTEM_LOAD=$($UPTIME_CMD | awk -F'load average:' '{print $2}')
      DISK_USAGE=$($DF_CMD -h / | awk 'NR==2{print $5}')
      DISK_TOTAL=$($DF_CMD -h / | awk 'NR==2{print $2}')
      DISK_USED=$($DF_CMD -h / | awk 'NR==2{print $3}')
      DISK_FREE=$($DF_CMD -h / | awk 'NR==2{print $4}')
      MEMORY_USAGE=$($FREE_CMD -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
      SWAP_USAGE=$($FREE_CMD -m | awk 'NR==3{printf "%.2f%%", $3*100/$2}')
      PROCESS_COUNT=$($PS_CMD -ef | wc -l)
      USER_COUNT=$($WHO_CMD | wc -l)
      IPV4_ADDRESS=$($IFCONFIG_CMD | awk '/inet / && !/127.0.0.1/{print $2}' | head -n 1)
      IPV6_ADDRESS=$($IFCONFIG_CMD | awk '/inet6/{print $2}' | head -n 1)
      DATE=$(date '+%d/%m/%Y %H:%M:%S')
      VERSION=$($LSB_RELEASE_CMD -d | awk -F"\t" '{print $2}')

      # Atualiza o arquivo de mensagem do terminal
      cat << EOF > /etc/motd

      Bem-vindo ao Servidor $VERSION

      Informações do sistema em $DATE:

      Carga do sistema:        $SYSTEM_LOAD
      Uso de /:                $DISK_USAGE de $DISK_TOTAL (Usado: $DISK_USED, Livre: $DISK_FREE)
      Uso de memória:          $MEMORY_USAGE
      Uso de swap:             $SWAP_USAGE
      Processos:               $PROCESS_COUNT
      Usuários logados:        $USER_COUNT
      Endereço IPv4:           $IPV4_ADDRESS
      Endereço IPv6:           $IPV6_ADDRESS

      EOF
