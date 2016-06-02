# hs-file-watcher
Aplicativo simples com a proposta de monitorar os arquivos contidos em um diretório especificado e executar uma ação parametrizável cada vez que um arquivo for alterado.

## Exemplos

**Uso: hs-file-wacher [[Path]] [[--ed][--ef][--exts]] [[--p][--pc][--cmd]]**

**Gerais**

Path => Indica o diretório a ser monitorado. Ainda que seja opcional, quando informado deve ser o primeiro item. Caso não seja informado, o diretório atual será utilizado como alvo. Ex: hs-file-watcher c:\myprj

**Modificadores**

--d --delay => Especifica a frequência das checagem por modificações (em segundos). Caso não seja informado, o valor default de 3 segundos será utilizado. Ex: hs-file-watcher --d 3

**Filters**

--ed --exclude-directories => Exclui os diretórios listados do monitoramento. Os argumentos de entrada são os nomes dos diretórios separados por espaços. Ex: hs-file-watcher --ed .stack-work dist log

--ef --exclude-files => Exclui os arquivos listados do monitoramento. Os argumentos de entrada são os nomes dosarquivos separados por espaços. Ex: hs-file-watcher --ef readme.md myprj.cabal log.txt

--exts --only-extensions => Limita o monitoramento aos arquivos com as extensões listadas. Os argumentos de entrada são as extensões separadas por espaços. Ex: hs-file-watcher --exts hs md cabal

**Actions**

--p --print => Imprime o texto indicado quando mudanças forem identificadas. O argumento de entrada é o texto a ser impresso. Ex: hs-file-watcher --p "Alterações!"

--pc --print-changed => Exibe lista  de arquivos que sofreram alterações. Comando não contém argumentos de entrada. Ex: hs-file-watcher --pc

--cmd --command => Executa um conjunto de comandos a cada modificação detectada. Os argumentos de entrada são os comandos à executar separados por espaços (Usar " para comandos que contenham espaços). Ex: hs-file-watcher --cmd "stack build" "stack install"