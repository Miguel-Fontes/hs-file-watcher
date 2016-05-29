module Actions.Tests where

import Test.Hspec
import Test.QuickCheck

import Actions.Action
import Actions.Arquivos

test :: IO ()
test = hspec $ do
  describe "Modulo Actions" $ do
      context "Tag" $ do
        it "should be tagged with tag printChangedAction" $ do
            show $ printChangedAction []
            `shouldBe` "printChangedAction"