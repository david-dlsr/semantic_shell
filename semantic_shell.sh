 #!/bin/bash

#####################
#     DESCRITIVO         #
#####################
#  Função: Ajudar na normatização do histórico de commits em um projeto, fazendo utilização dos commits semanticos
#  Fonte :  https://www.conventionalcommits.org/pt-br/v1.0.0-beta.4/
#  lembrando que ainda temos as tags semânticas que ficaram para um proximo release
#  script criado em shellscript utilizando recursos do shell


#######################
# VARIAVEIS GLOBAIS  #
#######################
branch_atual="$(git branch|grep ^*|awk '{print $2}')";
msg_tag_1="Melhor pratica é manipular um arquivo por commit com essa TAG";
msg_tag_N="Podem ser utilizados varios arquivos por commit com essa TAG";
resp_commit_path="";
Git="/usr/bin/git";
# LEMBRANDO 
# dirname  - mostra somente ate o ultimo diretorio em um path
# basename - mostra somente o nome de um arquivo em um path
#echo -e "Informações do script\n Nome Script: $(basename $0)\nPath Script: $(dirname ${BASH_SOURCE[0]})";
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";


########################
#  FUNCOES DO SCRIPT   #
########################
function config_proj(){
# Perguntando sobre novo path e testando caso utilize, se não utilizar usa o diretorio atual de execução do script
read -p "Iformar diretorio do commit [S|N]: " resp_commit_path;
case $resp_commit_path in
     s|S|y|Y)  read -p "Entre com o caminho do projeto" msg_commit_path; 
          if [ -d $msg_commit_path ] ;then echo "diretorio existe ! continuando ....";cd $msg_commit_path ;else echo "O diretorio nao existe...Saindao";fi;;
     *) echo "Sera usado o path atual: $DIR";;
esac;

# configurando atalhos para o git, estes seram utilizados dentro do proprio script
$Git config --global alias.b "branch";
$Git config --global alias.ck "checkout";
$Git config --global alias.st "status -s";
$Git config --global alias.stf "status";
$Git config --global alias.cm "commit -m";
$Git config --global alias.cam "commit -a -m";

# git commits semanticos
$Git config --global alias.cs "/bin/bash $PWD";

# logs interessantes
$Git config --global alias.l   "log --pretty=format:'%C(blue)%h -%<(12,trunc)%C(red)%cr - %<(11,trunc)%C(cyan)%cn - %C(white)%s - %C(yellow)%d'";
$Git config --global alias.lf  "log --pretty=format:'%C(blue)%h - %<(18,trunc)%C(green)%p - %<(20,trunc)%C(red)%ci - %<(11,trunc)%C(cyan)%cn - %C(white)%s - %C(yellow)%d'"
$Git config --global alias.lff "log --pretty=format:'%C(blue)%h - %<(18,trunc)%C(green)%p - %<(20,trunc)%C(red)%ci - %<(11,trunc)%C(cyan)%cn - %C(white)%s - %C(yellow)%d' --branches --tags" 

# git editor padrao vim
$Git config --global  core.editor "vim";
}

function seleciona_tag(){
git status ;    
clear;
echo -e "OLa DEV, Lembre de adicionar os arquivos para a staged area antes de chamar esse script !!!\nEscolha enre as Tags disponiveis para commit:\n\n\
\033[1;36m1)\033[1;31m feat:\033[0;33m     Utilizado quando se adiciona alguma nova funcionalidade do zero ao código/serviço/projeto\n\
\033[1;36m2)\033[1;31m fixH:\033[0;33m     Usado quando existem erros de código que estão causando bugs corrigidos na producao\n\
\033[1;36m3)\033[1;31m fix:\033[0;33m      Usado quando existem erros de código que estão causando bugs corrigidos no desenvolvimento\n\
\033[1;36m4)\033[1;31m refactor:\033[0;33m Utilizado na realização de uma refatoração que não causará impacto direto no código ou em qualquer lógica/regra de negócio\n\
\033[1;36m5)\033[1;31m style:\033[0;33m    Utilizado quando são realizadas mudanças no estilo e formatação do código que não irão impactar em nenhuma lógica do código\n\
\033[1;36m6)\033[1;31m test:\033[0;33m     Usado quando se realizam alterações de qualquer tipo nos testes, seja a adição de novos testes ou a refatoração de testes já existentes\n\
\033[1;36m7)\033[1;31m doc:\033[0;33m      Ideal para quando se adiciona ou modifica alguma documentação no código ou do repositório em questão\n\
\033[1;36m8)\033[1;31m env:\033[0;33m      Utilizado quando se modifica ou adiciona algum arquivo de CI/CD\n\
\033[1;36m9)\033[1;31m build:\033[0;33m    Usado quando se realiza alguma modificação em arquivos de build e dependências\033[0;37m\n"
read -p "Informe o numero que se enquadra no seu commit: " resp_com;
case $resp_com in 
     1) Tag="feat";arq_msg="$msg_tag_1";;
     2) Tag="fixH";arq_msg="$msg_tag_1";;
     3) Tag="fix";arq_msg="$msg_tag_1";;
     4) Tag="refactor";arq_msg="$msg_tag_N";;
     5) Tag="style";arq_msg="$msg_tag_N";;
     6) Tag="test";arq_msg="$msg_tag_N";;
     7) Tag="doc";arq_msg="$msg_tag_N";;
     8) Tag="env";arq_msg="$msg_tag_N";;
     9) Tag="build";arq_msg="$msg_tag_N";;
esac;
read -p "Informe o escopo do commit (enter para vazio): "  resp_escope;
export TAG escope;
}

function arq_alterado(){
cont=0;
if [ -z "$(git st|awk '{print $2}')" ]
     then 
          echo "Nao foi encontrado arquivo alterado na arvore...";       
       else
          while read entrada;
               do   
                     echo -e  "${cont}) ${entrada}\n";
                     arquiv[$cont]=$entrada;
                     let cont++; 
                     done< <(git st|awk '{print $2}')
                read -p "Selecione o numero do arquivo mais relevante  para mostrar no commit:  " resp_arq_alt;
                arquivo=${arquiv[$resp_arq_alt]};
                export arquivo;
fi;            
}

function msg_commit(){
     read -p "Entre com a mensagem do commit: " msg_final;
     export msg_final;
}

function infos(){
     echo "mostrando local do script $(basename $0)  - $DIR";
     sleep 3;
}

#######################
#    CORPO DO SCRIPT   #
#######################
# chamadas de funcoes
infos;
config_proj;
seleciona_tag;

# tratamento de escopo no commit
if [ -z $escope ]
     then  
          echo "$arq_msg $Tag";
          # chamadas de funcoes
          arq_alterado;
          msg_commit;
          echo "$Tag($resp_escope): $msg_final - Arq: $arquivo - In: $branch_atual"    
          MSG="$Tag($resp_escope): $msg_final - Arq: $arquivo - In: $branch_atual"; 
     else
          echo "$arq_msg $Tag";
          # chamadas de funcoes
          arq_alterado;
          msg_commit;
          echo "$Tag: $msg_final - Arq: $arquivo - In: $branch_atual"
          MSG="$Tag: $msg_final - Arq: $arquivo - In: $branch_atual";
fi;     

# Encerrando a mensagem final e realizando o commit 
read -p "A mensagem esta correta, podemos salvar ? [s\n] -> " resp_msg_final; 
case $resp_msg_final in 
     s|S|sim|SIM|sIM|Sim|siM) git cm "$MSG";;
     *) echo "Chame o semantic novamente ...";;
esac;
git status;
