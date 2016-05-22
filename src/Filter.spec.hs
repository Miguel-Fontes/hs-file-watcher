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

                     [Arquivo "." "a" "a", Arquivo "." ".." "a",
                      Arquivo "a" "a" "a", Arquivo "." "a" "a",
                      Arquivo "b" "a" "a", Arquivo "c" "a" "a",
                      Arquivo "." "a" "a", Arquivo "d" "a" ".",
                      Arquivo "d.hs" "a" "src", Arquivo "d.exe" "a" "src"]

                    `shouldBe` ([Arquivo "d.hs" "a" "src"] :: [Arquivo])
    it "should exclude a file by its name" $ do
      applyFilter (excludeFile "filetoexclude.txt")
                  [Arquivo {nome = "file.hs", dir = ".", modificado="21/05/2015"},
                   Arquivo {nome = "filetoexclude.txt", dir = ".", modificado="21/05/2015"}]

                   `shouldBe` ([Arquivo {nome = "file.hs", dir = ".", modificado="21/05/2015"}] :: [Arquivo])
