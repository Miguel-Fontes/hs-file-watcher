# hs-file-watcher
Monitoramento de arquivos contidos em um diretório e ```execução de ações no evento de alterações.```

O aplicativo possui uma interface CLI com opções para definição de seus parâmetros de execução.

Um dos motivos do desenvolvimento desta aplicação fora a necessidade de reexecução de uma suite de testes de unidade em cada alteração em um conjunto de arquivos de código fonte.

    $ hs-file-wacher --ed .git dist --exts hs --cmd "runhaskell c:\dev\app\tests\spec.hs"

Com as opções acima, o aplicativo irá monitorar o diretório atual do console e:
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

    $ stack build

##Instruções e Informações (TFM)
### Opções
As instruções abaixo são as mesmas impressas ao executar ```hs-file-watcher --help```. Todas são opcionais e podem ser combinadas. Para que o aplicativo inicie a execução, ao menos uma action deve ser informada.

    hs-file-wacher [Gerais [Path]] [Modificadores [--d]] [Filters [--ed][--ef][--exts]] [Actions [--p][--pc][--cmd][--cmd-p][--st]]

Grupo | Shorthand | Comando | Descrição
----------|----------| --------|----------
Gerais | - | - | Indica o diretório a ser monitorado. Ainda que seja opcional, quando informado deve ser o primeiro item. Caso não seja informado, o diretório atual será utilizado como alvo. ```Ex: hs-file-watcher c:\dev\myapp```
Modificadores |--d | --delay | Especifica a frequência das checagem por modificações (em segundos). Caso não seja informado, o valor default de 3 segundos será utilizado. ```Ex: hs-file-watcher --d 3```
Filters | --ed | --exclude-directories | Exclui os diretórios listados do monitoramento. Os argumentos de entrada são os nomes dos diretórios separados por espaços. ```Ex: hs-file-watcher --ed .stack-work dist log```
Filters | --ef | --exclude-files | Exclui os arquivos listados do monitoramento. Os argumentos de entrada são os nomes dos  arquivos separados por espaços. ```Ex: hs-file-watcher --ef readme.md myapp.cabal log.txt```
Filters |--exts | --only-extensions | Limita o monitoramento aos arquivos com as extensões listadas. Os argumentos de entrada são as extensões separadas por espaços. ```Ex: hs-file-watcher --exts hs md cabal```
Actions | --p | --print | Imprime o texto indicado quando mudanças forem identificadas. O argumento de entrada é o texto a ser impresso. ```Ex: hs-file-watcher --p "Alterações!"```
Actions | --pc | --print-changed| Exibe lista  de arquivos que sofreram alterações. Comando não contém argumentos de entrada. ```Ex: hs-file-watcher --pc```
Actions |--cmd | --command | Executa um conjunto de comandos a cada modificação detectada. Os argumentos de entrada são os comandos à executar separados por espaços (Usar " para comandos que contenham espaços). ```Ex: hs-file-watcher --cmd "stack build" "stack install"```
Actions | --cmd-p | --command-with-params | Executa um conjunto de comandos a cada modificação detectada. O comando receberá como parâmetro uma lista dos arquivos alterados no formato JSON (Mais informações sobre a estrutura do JSON no readme). Os argumentos de entrada são os comandos à executar separados por espaços. ```Ex: hs-file-watcher --cmd-p echo ==> executará ==> echo [{"nome": "arquivo.hs" ...}]```
Actions | --st | --stack-test | Executa o comando stack test. Não há argumentos de entrada. ```Ex: hs-file-watcher --st```

###Configurando opções para um projeto via arquivo .watcher-config
Para facilitar o uso do aplicativo, é possível criar um arquivo com o nome ".watcher.config" com as opções do hs-file-watcher. Isto evita a reescrita dos mesmos critérios.

O arquivo deverá conter as opções exatamente da forma como usariamos na linha de comando. Após a criação do arquivo, podemos executar o aplicativo sem informar opções.

Como exemplo, para executar o comando indicado no início do readme:

    -- Para executar o comando
    hs-file-wacher "C:\myapp\" --ed .git dist --exts hs --cmd "runhaskell c:\dev\app\tests\spec.hs"

    -- Podemos criar um arquivo .watcher-config no diretório C:\myapp com o conteúdo abaixo
    --ed .git dist --exts hs --cmd "runhaskell c:\dev\app\tests\spec.hs"

    -- Isto nos permitirá executar a aplicação sem informar opções
    $ hs-file-wacher

    -- Ao iniciar a execução, o aplicativo informará as opções lidas do arquivo com uma mensagem similar à:
    -> Obtidos parâmetros do arquivo .watcher-config e construído comando: hs-file-watcher --ed .git dist --exts hs --cmd "runhaskell c:\dev\app\tests\spec.hs"

Quando argumentos forem providos através da linha de comando, o arquivo será ignorado.

###Formato JSON usado pelo comando --cmd-p
Ao usar o action --cmd-p o aplicativo irá executar o comando indicado e adicionar como argumento de entrada a lista dos arquivos modificados no formato JSON.

Os dados contidos no JSON são os seguintes:

- Nome: O nome do arquivo
- Modificado: A data de modificação do arquivo
- Diretório: O diretório do arquivo

Exemplo de uma String JSON gerada pelo aplicativo:

    [
        {"nome": "Filter.hs"
        ,"modificado": "02/06/2016 14:11:02"
        ,"diretorio": "C:\\hs-file-watcher\\src\\Watcher\\"},

        {"nome": "Action.hs"
        ,"modificado": "10/06/2016 01:02:35"
        ,"diretorio": "C:\\hs-file-watcher\\src\\Watcher\\"}
    ]

Para ilustrar, o comando ```hs-file-watcher --cmd-p echo``` executará o comando echo para cada modificação de arquivo identificada, informando como argumento a String JSON.

     echo [{"nome": "Filter.hs" , "modificado": "02/06/2016 14:11:02" , "diretorio": "C:\\hs-file-watcher\\src\\Watcher\\"}]

###O Action --st --stack-test
Esta action é simplesmente um shorthand para ```hs-file-watcher --cmd "stack test"``` e foi criada para agilizar a configuração do monitoramento para projetos Haskell que utilizem Stack.

Para que a opção funcione, é necessário possuir o [Stack](http://www.haskellstack.org) instalado e configurado corretamente para seu projeto.