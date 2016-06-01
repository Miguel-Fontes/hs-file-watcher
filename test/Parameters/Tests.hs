module Parameters.Tests (test) where

import Test.Hspec
import Test.QuickCheck
import Data.Maybe

import Parameters.Parsers

command =
    ["C:\\Desenv\\",  "--print", "arquivoAlterado!", "--cmd", "dir", "--ed", ".stack-work", "--ef", "readme.md", "--only-extensions", "hs"]

commandOneArg =
    ["C:\\Desenv\\",  "--print", "arquivoAlterado!", "--ed", ".stack-work"]

test :: IO ()
test = hspec $ do
  describe "Modulo Parsers" $ do
    context "Utils" $ do
      it "takeOptions should return section from String" $ do
          takeOptions command
          `shouldBe` (["C:\\Desenv\\"])

    context "Errors" $ do
      it "should return a message when input contains a command that doesnt exist" $ do
           pendingWith "Nova implementação"

      it "should return a meessage when there's no actions defined on input" $ do
           pendingWith "Reimplementação"