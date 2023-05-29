### Informações do Servidor no Terminal

Um script para exibir informações do servidor toda vez que efetuar login pelo terminal, incluindo:

- Carga do sistema
- Uso de disco
- Uso de memória
- Processos em execução
- Usuários logados
- Endereços IP

As informações são atualizas automaticamente a cada login no terminal.


## Esse script foi projetado para rodar em sistemas Debian/Ubuntu, não testei em outras distribuições.


1 - Acesse o diretorio '/etc/update-motd.d/'

      cd /etc/update-motd.d/

2 - Agora precisamos criar o arquivo onde ficará o conteudo do script, você pode dar o nome que quiser, mas vou utilizar '99-mensagem-personalizada'

      nano 99-mensagem-personalizada

3 - Copie o conteudo e cole no arquivo.

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


No campo **MENSSAGEM** você pode personalizar a mensagem que será exibida no terminal, caso não queira nada, basta deixar o campo em branco **MENSSAGEM=""**

Nesse caso, o script est levantando as informações do sistema e enviando para o arquivo motd que fica localizado dentro de /etc 

4 - Salve o arquivo e saia do editor de texto **Ctrl + O** e **Ctrl + x**

5 - Agora precisamos tornar o script executavel, para isso:

      chmod +x update-motd.d/99-mensagem-personalizada

6 - Reinicie a sessão ou faça logout e login novamente para que as alterações tenham efeito.

Agora toda vez que for feito login o script será executado e atualizará as informações do arquivo /etc/motd com as informações atualizada.

Exemplo da mensagem em funcionamento:

![image](https://github.com/zudefoque/Informacoes-do-Servidor-Terminal/assets/47385049/9eb99a7f-c883-41b2-b766-fb5ad7d17921)
