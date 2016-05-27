module Parameters.Tests (test) where

import Test.Hspec
import Test.QuickCheck

import Arquivo.Watch
import Parameters.Parameters
import Parameters.Parsers
import Arquivo.Filter
import Arquivo.Arquivo

--tests = []

filesData =  [Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
             ,Arquivo {nome = "filetoexclude.txt", dir = ".", modificado="21/05/2015", isDirectory = False}
             ,Arquivo {nome = "directorytoexclude", dir = ".", modificado="21/05/2015", isDirectory = True}]

command =
    ["C:\\Desenv\\",  "--print", "arquivoAlterado!", "--ed", "node_modules",
     "bower_components", "--ef", "readme.md", "--only-extensions", "hs"]

test :: IO ()
test = hspec $ do
  describe "Modulo Parametros" $ do
    context "Directory Parser" $ do
      it "should return add a trailling \\ to derectory when needed" $ do
          parseDir (emptyParams, command) >>= Just . directory . fst
          `shouldBe` Just ("C:\\Desenv\\")

      it "should return the directory untouched when trailling \\ is already there" $ do
          parseDir (emptyParams, command) >>= Just . directory . fst
          `shouldBe` Just ("C:\\Desenv\\")

      it "should return a directory \".\" when no directory is supplied" $ do
          parseDir (emptyParams, drop 1 command) >>= Just . directory . fst
          `shouldBe` Just (".")

      it "should return the command untouched when there's no directory input" $ do
          parseDir (emptyParams, drop 1 command) >>= Just . snd
          `shouldBe` Just (drop 1 command)

    context "File Parser" $ do
      it "Should return a tuple (file, directory) when a file is received as Input" $ do
          parseFile "C:\\Desenv\\Prj\\File.hs"
          `shouldBe` ("File.hs","C:\\Desenv\\Prj\\")

      it "Should return a tuple (\"\", directory) when a directory is received as Input" $ do
          parseFile "C:\\Desenv\\Prj\\"
          `shouldBe` ("","C:\\Desenv\\Prj\\")

    context "Filter Parser" $ do
      it "Should create and apply a excludeDirectories Filter" $ do
          applyFilters [excludeDirectories ["directorytoexclude"]] filesData
          `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
                      ,Arquivo {nome = "filetoexclude.txt", dir = ".", modificado="21/05/2015", isDirectory = False}])

    context "Parameters Parser" $ do
      it "Should return section from String" $ do
          takeOptions command
          `shouldBe` (["C:\\Desenv\\"])