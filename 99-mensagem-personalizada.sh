  #!/bin/sh

  # Campo para o usuário digitar uma mensagem personalizada
  MENSSAGEM="Digite aqui sua mensagem personalizada"

  # Caminho para os executáveis
  UPTIME_CMD="/usr/bin/uptime"
  DF_CMD="/bin/df"
  FREE_CMD="/usr/bin/free"
  PS_CMD="/bin/ps"
  WHO_CMD="/usr/bin/who"
  IFCONFIG_CMD="/sbin/ifconfig"
  LSB_RELEASE_CMD="/usr/bin/lsb_release"

  # Obtém as informações necessárias
  SISTEMA=$($UPTIME_CMD | awk -F'load average:' '{print $2}')
  DISCO_USO=$($DF_CMD -h / | awk 'NR==2{print $5}')
  DISCO_TOTAL=$($DF_CMD -h / | awk 'NR==2{print $2}')
  DISCO_UTILIZADO=$($DF_CMD -h / | awk 'NR==2{print $3}')
  DISCO_LIVRE=$($DF_CMD -h / | awk 'NR==2{print $4}')
  MEMORIA_UTILIZACAO=$($FREE_CMD -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
  SWAP_UTILIZACAO=$($FREE_CMD -m | awk 'NR==3{printf "%.2f%%", $3*100/$2}')
  CONTAGEM_PROCESSOS=$($PS_CMD -ef | wc -l)
  CONTAGEM_USUARIOS=$($WHO_CMD | wc -l)
  ENDERECO_IPV4=$($IFCONFIG_CMD | awk '/inet / && !/127.0.0.1/{print $2}' | head -n 1)
  ENDERECO_IPV6=$($IFCONFIG_CMD | awk '/inet6/{print $2}' | head -n 1)
  DATA=$(date '+%d/%m/%Y %H:%M:%S')
  VERSAO=$($LSB_RELEASE_CMD -d | awk -F"\t" '{print $2}')

  # Atualiza o arquivo de mensagem do terminal
  cat << EOF > /etc/motd

  $MENSSAGEM - $VERSAO

  Informações do sistema em $DATA:

  Sistema:                 $SISTEMA
  Disco usado:             $DISCO_USO de $DISCO_TOTAL (Utilizado: $DISCO_UTILIZADO, Livre: $DISCO_LIVRE)
  Utilização de memória:   $MEMORIA_UTILIZACAO
  Utilização de swap:      $SWAP_UTILIZACAO
  Contagem de processos:   $CONTAGEM_PROCESSOS
  Contagem de usuários:    $CONTAGEM_USUARIOS
  Endereço IPv4:           $ENDERECO_IPV4
  Endereço IPv6:           $ENDERECO_IPV6

  EOF
