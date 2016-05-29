module Help.Tests where

import Test.Hspec
import Test.QuickCheck

import Help.Comando

test :: IO ()
test = hspec $ do
  describe "Modulo Help" $ do
      context "Show Instance" $ do
        it "should print the object" $ do
            show $ Comando "hs-file-wacher" [[Single "--ef"], [Single "--exts"]]
            `shouldBe` "hs-file-wacher [[--ef],[--exts]]"

      context "Usage" $ do
          context "Single Option" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Comando "hs-file-wacher" [[Single "--ef"], [Single "--exts"]]
                `shouldBe` "hs-file-wacher [--ef] [--exts]"
          context "Extended Option" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Comando "hs-file-wacher" [[Extended ["--ef", "--exclude-files"]], [Extended ["--exts", "--only-extensions"]]]
                `shouldBe` "hs-file-wacher [--ef] [--exts]"
          context "Mixed Option" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Comando "hs-file-wacher" [[Extended ["--ef", "--exclude-files"]], [Single "--exts"]]
                `shouldBe` "hs-file-wacher [--ef] [--exts]"
          context "Several Options" $ do
            it "Should return a formatted string with command usage information" $ do
                usage $ Comando "hs-file-wacher" [filtersList, actionsList]
                `shouldBe` "hs-file-wacher [--ed] [--ef] [--exts] [--p] [--pc] [--cmd]"

--filtersList :: [Option]
filtersList = [Extended ["--ed", "--exclude-directories"]
              ,Extended ["--ef", "--exclude-files"]
              ,Extended ["--exts", "--only-extensions"]]

--actionsList :: [Option]
actionsList = [Extended ["--p", "--print"]
              ,Extended ["--pc", "--print-changed"]
              ,Extended ["--cmd", "--command"]]