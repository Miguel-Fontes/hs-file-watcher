module Watcher.Tests (test) where

import Test.Hspec
import Test.QuickCheck

import Watcher.Filter
import Watcher.Arquivo
import Watcher.Watch
import Watcher.Action

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
        applyFilters [onlyExtensions ["hs"], noPoints] filesData

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
        applyFilters ([excludeFiles ["d.hs"], onlyExtensions ["hs"]]) filesData
        `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado="21/05/2015", isDirectory = False}
                    ,Arquivo {nome = "directorytoexclude", dir = ".", modificado = "a", isDirectory = True}])
      context "Tag" $ do
        it "should be tagged with onlyExtensions hs" $ do
           show $ onlyExtensions ["hs"]
           `shouldBe` "onlyExtensions: [\"hs\"]"

        it "should be tagged with noPoints" $ do
           show noPoints
           `shouldBe` "noPoints"

    context "Actions" $ do
      context "Tag" $ do
        it "should be tagged with tag printChangedAction" $ do
            show $ printChangedAction []
            `shouldBe` "printChangedAction"