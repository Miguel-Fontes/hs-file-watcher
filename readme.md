# hs-file-watcher
Monitoramento de arquivos contidos em um diretório e ```execução de ações no evento de alterações.```

O aplicativo possui uma interface CLI com opções para definição de seus parâmetros de execução.

Um dos motivos do desenvolvimento desta aplicação fora a necessidade de reexecução de uma suite de testes de unidade em cada alteração em um conjunto de arquivos de código fonte.

    hs-file-wacher --ed .git dist --exts hs --cmd "runhaskell c:\dev\app\tests\spec.hs"

Utilizando a instrução abaixo, o aplicativo irá monitorar o diretório atual selecionado no console e:
- ignorar o diretório ".git" e "dist"
- ignorar os arquivos com extensão diferente de "hs"
- No caso de mudanças, executar o comando "runhaskell c:\dev\prj\tests\spec.hs".

## Instalação
1. Baixe o aplicativo da página de releases (clique neste link)
2. Adicione o arquivo ao seu PATH
3. No terminal, execute hs-file-watcher com os parâmetros desejados.
4. Profit!

## Build Local
Para executar um buid local do aplicativo, é necessário possuir o [stack](https://github.com/commercialhaskell/stack) instalado. Com isto fora do caminho, executar o build da aplicação é exatamente o esperado:

    stack build

## Opções
O texto abaixo é retirado do texto impresso ao executar o comando com o flag ```--help```. Todas as opções são opcionais e podem ser combinadas sem problemas. Para que o aplicativo inicie a execucão, ao menos uma action deve ser informada.

    hs-file-wacher [[Path]] [[--ed][--ef][--exts]] [[--p][--pc][--cmd]]

####**Gerais**

__Path__ => Indica o diretório a ser monitorado. Ainda que seja opcional, quando informado deve ser o primeiro item. Caso não seja informado, o diretório atual será utilizado como alvo. ```Ex: hs-file-watcher c:\dev\myapp```

**Modificadores**

__--d --delay__ => Especifica a frequência das checagem por modificações (em segundos). Caso não seja informado, o valor default de 3 segundos será utilizado. ```Ex: hs-file-watcher --d 3```

####**Filters**

__--ed --exclude-directories__ => Exclui os diretórios listados do monitoramento. Os argumentos de entrada são os nomes dos diretórios separados por espaços. ```Ex: hs-file-watcher --ed .stack-work dist log```

__--ef --exclude-files__ => Exclui os arquivos listados do monitoramento. Os argumentos de entrada são os nomes dos arquivos separados por espaços. ```Ex: hs-file-watcher --ef readme.md myapp.cabal log.txt```

__--exts --only-extensions__ => Limita o monitoramento aos arquivos com as extensões listadas. Os argumentos de entrada são as extensões separadas por espaços. ```Ex: hs-file-watcher --exts hs md cabal```

####**Actions**

__--p --print__ => Imprime o texto indicado quando mudanças forem identificadas. O argumento de entrada é o texto a ser impresso. ```Ex: hs-file-watcher --p "Alterações!"```

__--pc --print-changed__ => Exibe lista  de arquivos que sofreram alterações. Comando não contém argumentos de entrada. ```Ex: hs-file-watcher --pc```

__--cmd --command__ => Executa um conjunto de comandos a cada modificação detectada. Os argumentos de entrada são os comandos à executar separados por espaços (Usar " para comandos que contenham espaços). ```Ex: hs-file-watcher --cmd "stack build" "stack install"```

__--st --stack-test__ => Executa o comando stack test. Não há argumentos de entrada. ```Ex: hs-file-watcher --st```