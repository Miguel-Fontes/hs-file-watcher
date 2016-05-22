import Test.Hspec
import Test.QuickCheck

import Arquivo.Filter
import Arquivo.Arquivo
import Arquivo.Watch

main :: IO ()
main = hspec $ do
  describe "applyFilters" $ do
    it "returns only .hs files" $ do
      applyFilters [onlyExtension "hs",
                    noPoints,
                    excludeDirectory ".",
                    customFilter (\x -> nome x /= "a"),
                    customFilter (\x -> nome x /= "c")]

                     [Arquivo "." "a" "a" False, Arquivo "." ".." "a" False,
                      Arquivo "a" "a" "a" False, Arquivo "." "a" "a" False,
                      Arquivo "b" "a" "a" False, Arquivo "c" "a" "a" False,
                      Arquivo "." "a" "a" False, Arquivo "d" "a" "." False,
                      Arquivo "d.hs" "a" "src" False, Arquivo "d.exe" "a" "src" False]

                    `shouldBe` ([Arquivo "d.hs" "a" "src" False] :: [Arquivo])
    it "should exclude a file by its name" $ do
      applyFilter (excludeFile "filetoexclude.txt")
                  [Arquivo {nome = "file.hs", dir = ".", modificado = "21/05/2015", isDirectory = False},
                   Arquivo {nome = "filetoexclude.txt", dir = ".", modificado="21/05/2015", isDirectory = False}]

                   `shouldBe` ([Arquivo {nome = "file.hs", dir = ".", modificado="21/05/2015", isDirectory = False}] :: [Arquivo])
