module Help.Tests where

import Test.Hspec
import Test.QuickCheck

import Command.Command
import Help.Printer

test :: IO ()
test = hspec $ do
  describe "Modulo Help" $ do
      context "Show Instance" $ do
        it "should print the object" $ do
            show $ Command "hs-file-wacher" [OptionGroup "Teste" [Single "--ef" "Exclui arquivos"]
                                            ,OptionGroup "Teste" [Single "--exts" "Limita exts"]]
            `shouldBe`  "hs-file-wacher [Teste - [--ef - Exclui arquivos],Teste - [--exts - Limita exts]]"

      context "Usage" $ do
          context "Single Option" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Command "hs-file-wacher" [OptionGroup "Teste" [Single "--ef" ""]
                                                 ,OptionGroup "Teste" [Single "--exts" ""]]
                `shouldBe` "hs-file-wacher [[--ef]] [[--exts]]\n\n"
          context "Extended Option" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Command "hs-file-wacher" [OptionGroup "Teste" [Extended ["--ef", "--exclude-files"] ""]                                         ,OptionGroup "Teste" [Extended ["--exts", "--only-extensions"] ""]]
                `shouldBe` "hs-file-wacher [[--ef]] [[--exts]]\n\n"
          context "Mixed Option" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Command "hs-file-wacher" [OptionGroup "Teste" [Extended ["--ef", "--exclude-files"] ""]
                                                 ,OptionGroup "Teste"  [Single "--exts" ""]]
                `shouldBe` "hs-file-wacher [[--ef]] [[--exts]]\n\n"
          context "Several Options" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Command "hs-file-wacher" [OptionGroup "Título" [FixedText "[Caminho]"]
                                                 ,OptionGroup "Filters"  filtersList
                                                 ,OptionGroup "Actions"  actionsList]
                `shouldBe` "hs-file-wacher [[Caminho]] [[--ed][--ef][--exts]] [[--p][--pc][--cmd]]\n\n"
      context "Printer" $ do
            it "should print the description of all commands " $ do
                --printHelp (TwoColumns (40,100)) hsCommand
                --`shouldBe` "meh"
                pendingWith "Checar a documentação e identificar como construir uma condicional para percorrer a string e avaliar se esta possui todos os comandos em seu conteúdo."


hsCommand = Command "hs-file-wacher" [OptionGroup "Título" [FixedText "[Caminho] "]
                                     ,OptionGroup "Filters"  filtersList
                                     ,OptionGroup "Actions"  actionsList]

filtersList :: [Option]
filtersList = [Extended ["--ed", "--exclude-directories"]
                         "Exclui os diretórios listado do monitoramento. Os argumentos de entrada são os nomes dos diretórios. Ex: -ed .stack-work dist log"
              ,Extended ["--ef", "--exclude-files"]
                         "Exclui os arquivos indicados do monitoramento. Os argumentos de entrada são os nomes dos arquivos. Ex: --ef readme.md myprj.cabal log.txt"
              ,Extended ["--exts", "--only-extensions"]
                         "Limita o monitoramento à apenas às extensões listadas. Os argumentos de entrada são as extensões. Ex: --exts hs"]

actionsList :: [Option]
actionsList = [Extended ["--p", "--print"]
                         "Imprime o texto indicado quando mudanças forem identificadas. Ex: --p \"Alterações!\""
              ,Extended ["--pc", "--print-changed"]
                         "Exibe lista de arquivos que sofreram alterações no console. Ex: --pc"
              ,Extended ["--cmd", "--command"]
                         "Executa um comando cada vez que uma modificação é detectada. Os argumentos de entrada são os comandos à executar. Ex: --cmd \"stack build\" \"stack install\" "]