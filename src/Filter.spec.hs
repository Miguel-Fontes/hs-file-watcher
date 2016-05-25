import Test.Hspec
import Test.QuickCheck

import Arquivo.Filter
import Arquivo.Arquivo
import Arquivo.Watch


filesData =  [Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
             ,Arquivo {nome = "filetoexclude.txt", dir = ".", modificado="21/05/2015", isDirectory = False}
             ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = ".", dir = "..", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "a", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "b", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "c", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = ".", dir = "a", modificado = "a", isDirectory = False}
             ,Arquivo {nome = "d", dir = "a", modificado = ".", isDirectory = False}
             ,Arquivo {nome = "d.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
             ,Arquivo {nome = "d.exe", dir = "src", modificado = "a", isDirectory = False}]


main :: IO ()
main = hspec $ do
  describe "Filters" $ do
    it "Filter by extension returns only .hs files" $ do
      applyFilters [onlyExtension "hs"
                    ,noPoints]

                    filesData

                    `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
                                ,Arquivo {nome = "d.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}])

    it "should exclude a file by its name" $ do
      applyFilters ([excludeFile "d.hs", onlyExtension "hs"])
                     filesData
                     `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado="21/05/2015", isDirectory = False}] :: [Arquivo])
