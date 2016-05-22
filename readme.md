# hs-file-watcher
Aplicativo simples com a proposta de monitorar os arquivos contidos em um diretório especificado e executar uma ação cada vez que um arquivo for alterado.

## Todo List
- [x] Filtrar arquivos por extensão
- [x] Excluir arquivos por nome
- [x] Excluir diretórios por nome
- [x] Separar funcionalidades em módulos
- [ ] Definir parâmetros de entrada e seus formatos
- [ ] Organização dos testes da aplicação
- [x] Recursão em todos os subdiretórios do diretório indicado
- [ ] Ação parametrizável quando alterações forem detectadas
- [ ] Permitir que mais de uma ação seja executada por hook


## Log
- 20/05/2016: Função core do aplicativo (identificar alterações em arquivos) concluída.
- 21/05/2016: Módulos, primeiro arquivo para testes criado (ainda por organizar melhor), filtros e funções adequadas para sua execução.
- 22/05/2016:
    - Recursão para obtenção de arquivos em subdiretórios e filtros de arquivos. Refatorar para remover os filtros que estão em hardcode e verificar a possibilidade de abstrair de execução de ações IO recursivamente.
    - Criado módulo Utils para conter funcionalidades genéricas. Submodulo IOFold foi criado para abstrair padrões de recursão executando ações IO.
    - Next task: Entrada de parâmetros via linha de comando