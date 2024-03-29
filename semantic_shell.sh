 #!/bin/bash

###########################
#     DESCRITIVO         #
###########################
#  Função: Ajudar na normatização do histórico de commits em um projeto, fazendo utilização dos commits semanticos
#  Fonte :  https://www.conventionalcommits.org/pt-br/v1.0.0-beta.4/
#  lembrando que ainda temos as tags semânticas que ficarão para um próximo release
#  script criado em shellscript utilizando recursos do shell
#  script desenvolvido para ser executado pelo bash 


#######################
#  VARIAVEIS GLOBAIS  #
#######################
#branch_atual="$(git branch --show-current)";
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
function branchAtual(){ 
     branch_atual="$(${Git} branch --show-current)";echo "branch_atual: ${branch_atual}" 
     }


function config_proj(){
echo -e "\033[7;30;41m - Doing - \033[1;33m Configurando path do projeto... \033[0m\n"	

if [ -z "${1}" ]
   then 
       # Perguntando sobre novo path e testando caso utilize, se não utilizar usa o diretorio atual de execução do script
      echo "Será realizado o commite do projeto semantic"
      resp_commit_path="N";
   else
      msg_commit_path="${1}"; 
      resp_commit_path="Y";
fi

case $resp_commit_path in
     s|S|y|Y)  
          if [ -d $msg_commit_path ] 
             then 
                   echo "Diretorio existe! continuando....";
                   cd $msg_commit_path;
                   echo "PATH-ATUAL: $PWD"
                   branchAtual;
                   read -p "Informe o nome da branch onde sera realizado o commit: " branch_new;
                   git ck -b ${branch_new} && branchAtual;
              else
                   echo "O diretorio nao existe...Saindo";
          fi;;
     *) echo -e "          Será usado o path atual para o commit:\n   - $DIR";sleep 2;;
esac;



echo -e "\033[7;30;41m Doing \033[1;33m configurando alias para o git do projeto...\033[0m"	
# configurando atalhos para o git, estes seram utilizados dentro do proprio script
$Git config --global alias.b "branch";
$Git config --global alias.ck "checkout";
$Git config --global alias.st "status -s";
$Git config --global alias.stf "status";
$Git config --global alias.cm "commit -m";
$Git config --global alias.cam "commit -a -m";

# git commits semanticos
#$Git config --global alias.cs "! /bin/bash $PWD/$0";
$Git config --global alias.Lcs  "! /bin/bash $0";

# logs interessantes
$Git config --global alias.l   "log --pretty=format:'%C(blue)%h -%<(12,trunc)%C(red)%cr - %<(11,trunc)%C(cyan)%cn - %C(white)%s - %C(yellow)%d'";
$Git config --global alias.lf  "log --pretty=format:'%C(blue)%h - %<(18,trunc)%C(green)%p - %<(20,trunc)%C(red)%ci - %<(11,trunc)%C(cyan)%cn - %C(white)%s - %C(yellow)%d'"
$Git config --global alias.lff "log --pretty=format:'%C(blue)%h - %<(18,trunc)%C(green)%p - %<(20,trunc)%C(red)%ci - %<(11,trunc)%C(cyan)%cn - %C(white)%s - %C(yellow)%d' --branches --tags" 

# git editor padrao vim
$Git config --global  core.editor "vim";
}

function seleciona_tag(){
#clear;
# integrando arquivos modificados excluidos ou adicionados antes de realizar o commit
echo -e "\033[1;33mTodos os aquivos EDITADOS|DELETADOS|NOVOS foram incluidos na STAGE AREA\033[m\n"
git add --all .
echo -e "\033[7;30;41m Doing - \033[1;33mEscolha enre as Tags disponíveis para commits semânticos:\033[m\n\n\
\033[1;36m1)\033[1;31m feat:\033[0;33m     Utilizado quando se adiciona alguma nova funcionalidade do zero ao código/serviço/projeto\033[m\n\
\033[1;36m2)\033[1;31m fixH:\033[0;33m     Usado quando existem erros de código que estão causando bugs corrigidos na producao\033[m\n\
\033[1;36m3)\033[1;31m fix:\033[0;33m      Usado quando existem erros de código que estão causando bugs corrigidos no desenvolvimento\033[m\n\
\033[1;36m4)\033[1;31m refactor:\033[0;33m Utilizado na realização de uma refatoração que não causará impacto direto no código ou em qualquer lógica/regra de negócio\033[m\n\
\033[1;36m5)\033[1;31m style:\033[0;33m    Utilizado quando são realizadas mudanças no estilo e formatação do código que não irão impactar em nenhuma lógica do código\033[m\n\
\033[1;36m6)\033[1;31m test:\033[0;33m     Usado quando se realizam alterações de qualquer tipo nos testes, seja a adição de novos testes ou a refatoração de testes já existentes\033[m\n\
\033[1;36m7)\033[1;31m doc:\033[0;33m      Ideal para quando se adiciona ou modifica alguma documentação no código ou do repositório em questão\033[m\n\
\033[1;36m8)\033[1;31m env:\033[0;33m      Utilizado quando se modifica ou adiciona algum arquivo de CI/CD\033[m\n\
\033[1;36m9)\033[1;31m build:\033[0;33m    Usado quando se realiza alguma modificação em arquivos de build e dependências\033[m\n"
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
if [ -z "$(git status -s|awk '{print $2}')" ]
     then 
          echo -e "\nNao exitem alterações para commitar... Saindo do script\n";
          exit;       
       else
          while read entrada;
               do   
                     echo -e  "${cont}) ${entrada}\n";
                     arquiv[$cont]=$entrada;
                     let cont++; 
                     done< <(git st|awk '{print $2}')
                read -p "Selecione o numero do arquivo mais relevante  para mostrar no commit:  " resp_arq_alt;
                echo -e "\n";
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
     clear;
}

########################
#    CORPO DO SCRIPT   #
########################

# chamadas de funcoes
infos;
config_proj $1;
arq_alterado;
seleciona_tag;

# tratamento de escopo no commit
if [ -z $escope ]
     then  
          echo "$arq_msg $Tag";
          # chamadas de funcoes
          #arq_alterado;
          msg_commit;
          echo "$Tag($resp_escope): $msg_final - Arq: $arquivo - In: $branch_atual";    
          MSG="$Tag($resp_escope): $msg_final - Arq: $arquivo - In: $branch_atual"; 
     else
          echo "$arq_msg $Tag";
          # chamadas de funcoes
          arq_alterado;
          msg_commit;
          echo "$Tag: $msg_final - Arq: $arquivo - In: $branch_atual";
          MSG="$Tag: $msg_final - Arq: $arquivo - In: $branch_atual";
fi;     

# Encerrando a mensagem final e realizando o commit 
read -p "A mensagem esta correta, podemos salvar ? [s\n] -> " resp_msg_final; 
case $resp_msg_final in 
     s|S|sim|SIM|sIM|Sim|siM) git cm "$MSG";;
     *) echo "Chame o semantic novamente ...";;
esac;
git status;
