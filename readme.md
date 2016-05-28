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
- [ ] Criar 'chave' para ativar e desativar log de execução no console
- [ ] Permitir que usuário não insira um diretório e, para este caso, considerar que o diretório a ser monitorado é o atual
- [ ] Retornar mensagem descritiva no caso de erros durante o processamento do input
- [x] Escrever testes faltantes


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
- 26/05/2015:
    - Configurada a ferramenta de Build stack no projeto.
    - Organização dos testes e módulo Action em diretórios específicos
    - stack build e stack exec podem ser utilizados para construir e testar a aplicação
- 27/05/2015:
    - Removida limitação na execução de apenas uma ação. Diversas ações podem ser definidas e serão executadas sequencialmente quando mudanças forem identificadas.
    - Modularizada aplicação em modulos library, executavel e tests via cabal.
    - Executar stack tests agora testa a aplicação utilizando os módulos de teste definidos.
    - Modulos de teste devem exportar uma função test que executa todos os testes.
    - Cada módulo de teste deve importado em test\spec e executado no chain do bloco do.
- 28/05/2015:
    - Finalização de construção e organização do módulo de testes e adição de testes.


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