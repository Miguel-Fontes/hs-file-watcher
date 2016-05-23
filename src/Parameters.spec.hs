import Test.Hspec
import Test.QuickCheck

import Arquivo.Watch
import Parameters.Parsers
import Arquivo.Filter
import Arquivo.Arquivo

filesData =  [Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
             ,Arquivo {nome = "filetoexclude.txt", dir = ".", modificado="21/05/2015", isDirectory = False}
             ,Arquivo {nome = "directorytoexclude", dir = ".", modificado="21/05/2015", isDirectory = True}]

main :: IO ()
main = hspec $ do
  describe "Directory Parser" $ do
    it "should return add a trailling \\ to derectory when needed" $ do
        parseDir "C:\\Desenv"
        `shouldBe` "C:\\Desenv\\"

    it "should return the directory untouched when trailling \\ is already there" $ do
        parseDir "C:\\Desenv\\"
        `shouldBe` "C:\\Desenv\\"

  describe "File Parser" $ do
    it "Should return a tuple (file, directory) when a file is received as Input" $ do
        parseFile "C:\\Desenv\\Prj\\File.hs"
        `shouldBe` ("File.hs","C:\\Desenv\\Prj\\")

    it "Should return a tuple (\"\", directory) when a directory is received as Input" $ do
        parseFile "C:\\Desenv\\Prj\\"
        `shouldBe` ("","C:\\Desenv\\Prj\\")

  describe "Filter Parser" $ do
    it "Should create and apply a excludeDirectories Filter" $ do
        applyFilters [parseFilter "directorytoexclude"] filesData
        `shouldBe` ([Arquivo {nome = "file.hs", dir = "src", modificado = "21/05/2015", isDirectory = False}
                    ,Arquivo {nome = "filetoexclude.txt", dir = ".", modificado="21/05/2015", isDirectory = False}])
