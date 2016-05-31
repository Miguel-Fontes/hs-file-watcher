# hs-file-watcher
Aplicativo simples com a proposta de monitorar os arquivos contidos em um diretório especificado e executar uma ação cada vez que um arquivo for alterado.

## Todo List
- [x] Filtrar arquivos por extensão
- [x] Excluir arquivos por nome
- [x] Excluir diretórios por nome
- [x] Separar funcionalidades em módulos
- [x] Definir parâmetros de entrada e seus formatos
- [x] Refatorar módulo parâmetros
- [x] Organização e Integração dos testes da aplicação e integração à ferramenta de build
- [x] Recursão em todos os subdiretórios do diretório indicado
- [x] Ação parametrizável quando alterações forem detectadas
- [x] Permitir que mais de uma ação seja executada por hook
- [x] Construir action para executar um programa externo
- [x] Criar script de build para projeto
- [x] Retornar mensagem descritiva no caso de erros durante o processamento do input
- [x] Remover a lista vazia da tupla de saída da função Parameters.Parsers.parseParameters
- [x] Escrever testes faltantes
- [x] Permitir que usuário não insira um diretório e, para este caso, considerar que o diretório a ser monitorado é o atual
- [x] Retornar mensagem formatada com as opções disponíveis para uso no caso de erros
- [x] Executar ações na ordem em que são informadas no input
- [x] Incluir controle de possíveis exceções na execução de programas externos via actions <- CURRENT
- [x] Criar / mover dispatcher de filtros e actions para seus respectivos módulos (atualmente, há uma lista em Parameters.Parsers.hs)
- [x] Criar comando --help para exibição da ajuda quando desejado pelo usuário
- [ ] Implementar log de execução
- [ ] Melhorar texto descrevendo os arquivos alterados impressos no console via action --pc

## Log
- 20/05/2016: Função core do aplicativo (identificar alterações em arquivos) concluída.
- 21/05/2016: Módulos, primeiro arquivo para testes criado (ainda por organizar melhor), filtros e funções adequadas para sua execução.
- 22/05/2016:
    - Recursão para obtenção de arquivos em subdiretórios e filtros de arquivos. Refatorar para remover os filtros que estão em hardcode e verificar a possibilidade de abstrair de execução de ações IO recursivamente.
    - Criado módulo Utils para conter funcionalidades genéricas. Submodulo IOFold foi criado para abstrair padrões de recursão executando ações IO.
    - Next task: Entrada de parâmetros via linha de comando
- 24/05/2016: Parsers para funções da linha de comando funcional. Código precisa ser refatorado.
- 25/05/2016:
    - Adicionados tags em filters e actions possibilitando a impressão de texto descritivo usando um instance show
    - Corrigido Bug no filtro por extensão onde os diretórios também eram filtrados
    - Adicionado tratamento para argumentos no main
    - Modulo de parâmetros refatorado. A lógica para matching de options da linha de comando ainda pode ser melhorado. Na forma como está, a cada novo Action ou Filter o módulo Parametros.Parser deverá ser alterado também.
    - Adicionada action para execução de programa externo. Opção --cmd ou --command
- 26/05/2016:
    - Configurada a ferramenta de Build stack no projeto.
    - Organização dos testes e módulo Action em diretórios específicos
    - stack build e stack exec podem ser utilizados para construir e testar a aplicação
- 27/05/2016:
    - Removida limitação na execução de apenas uma ação. Diversas ações podem ser definidas e serão executadas sequencialmente quando mudanças forem identificadas.
    - Modularizada aplicação em modulos library, executavel e tests via cabal.
    - Executar stack tests agora testa a aplicação utilizando os módulos de teste definidos.
    - Modulos de teste devem exportar uma função test que executa todos os testes.
    - Cada módulo de teste deve importado em test\spec e executado no chain do bloco do.
- 28/05/2016:
    - Finalização de construção e organização do módulo de testes e adição de testes.
    - Adição de mensagens indicando que o input é inválido para os casos em que nenhuma ação é definida e onde a opção informada não existe.
    - Usuário poderá omitir o diretório e definir apenas os filtros e ações - o diretório corrente será utilizado como alvo.
    - Alterado o tipo Action para que este receba os arquivos que sofreram alterações, possibilitando ações especificamente sobre eles.
- 29/05/2016:
    - Inversão da ordem dos campos filter e actions dos parâmetros para que eles representem a ordem que as opções foram inputadas.
    - Adição de um módulo para testes de Actions.
    - Adicionado tratamento para interceptar exceções na execução de comandos externos, exibicão de uma mensagem informativa e permitir a continuidade da execução da aplicação.
- 30/05/2016:
    - Implementação inicial do texto de ajuda a ser exibido via opção --help ou no caso de algum erro de parsing. O código inicial está funcional mas precisa ser refatorado.
    - Executada generalização do layout para printing no console através de tipo Layout. Refatorado código do módulo Help.Printer.
    - Criado módulo Comando contendo tipos para definição de um comando. Este tipo é o ponto de partida para os parsers e para construção de mensagem de ajuda.
    - Adicionada função para identificar se foi inputado --help pelo usuário e, neste caso, imprimir o texto de ajuda.
- 31/05/2016:
    - Novos testes para o módulo Utils.String
    - Definição de funções exportadas de cada módulo. Merece revisão futura, principalmente no caso de tipos e construtores exportados.
    - Incluso separador de grupo no texto de help
    - Correções em textos


## Exemplos
    --print -> imprime o texto indicado quando alterações forem identificadas
    hs-file-watcher C:\meu-projeto\ --print "Arquivos Alterados"

    --only-ext ou --only-extensions -> filtra os arquivos que não sejam das extensões relacionadas
    hs-file-watcher C:\meu-projeto\ --print "Arquivos Alterados" --only-ext hs

    --ed ou --exclude-directories -> exclui todos os diretórios relacionados do monitoramento
    hs-file-watcher C:\meu-projeto\ --print "Arquivos Alterados" --ed .git

    --ef ou --exclude-files -> exclui os arquivos relacionados
    hs-file-watcher C:\meu-projeto\ --print "Arquivos Alterados" --ef readme.md

    --cmd ou --command -> executa o comando quando alterações forem identificadas nos arquivos
    hs-file-watcher C:\meu-projeto\ --cmd "cd c:\meu-projeto\ && runhaskell modulo.spec.hs" --ef readme.md