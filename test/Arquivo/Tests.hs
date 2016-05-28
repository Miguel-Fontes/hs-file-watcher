module Arquivo.Tests (test) where

import Test.Hspec
import Test.QuickCheck

import Arquivo.Filter
import Arquivo.Arquivo
import Arquivo.Watch

filesData =  [Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
             ,Arquivo {nome = "filetoexclude.txt", dir = "src", modificado="21/05/2015", isDirectory = False}
             ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "a", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "b", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "c", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "d", dir = "a", modificado = ".", isDirectory = False}
             ,Arquivo {nome = "d.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
             ,Arquivo {nome = "directorytoexclude", dir = ".", modificado = "a", isDirectory = True}]


test :: IO ()
test = hspec $ do
  describe "Modulo Arquivo" $ do
    context "Filters" $ do
      it "Filter by extension returns only .hs files" $ do
        applyFilters [onlyExtension "hs", noPoints] filesData

        `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
                    ,Arquivo {nome = "d.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
                    ,Arquivo {nome = "directorytoexclude", dir = ".", modificado = "a", isDirectory = True}])

      it "Should create and apply a excludeDirectories Filter" $ do
          applyFilters [excludeDirectories ["directorytoexclude", "a"]] filesData
          `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
                       ,Arquivo {nome = "filetoexclude.txt", dir = "src", modificado="21/05/2015", isDirectory = False}
                       ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
                       ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
                       ,Arquivo {nome = "a", dir = "a", modificado = "a", isDirectory = False}
                       ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
                       ,Arquivo {nome = "b", dir = "a", modificado = "a", isDirectory = False}
                       ,Arquivo {nome = "c", dir = "a", modificado = "a", isDirectory = False}
                       ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
                       ,Arquivo {nome = "d", dir = "a", modificado = ".", isDirectory = False}
                       ,Arquivo {nome = "d.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}])

      it "should exclude a file by its name" $ do
        applyFilters ([excludeFile "d.hs", onlyExtension "hs"]) filesData
        `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado="21/05/2015", isDirectory = False}
                    ,Arquivo {nome = "directorytoexclude", dir = ".", modificado = "a", isDirectory = True}])