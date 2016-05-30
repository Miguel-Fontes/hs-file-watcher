module Utils.String.Tests (test) where

import Test.Hspec
import Test.QuickCheck

import Utils.String


test :: IO ()
test = hspec $ do
  describe "Modulo String" $ do
      context "rtrim" $ do
        it "should remove all spaces at the end of the string" $ do
          rtrim "string teste    "
          `shouldBe` "string teste"

        it "should let any other spaces of the string untouuched" $ do
           rtrim "  string teste"
          `shouldBe` "  string teste"