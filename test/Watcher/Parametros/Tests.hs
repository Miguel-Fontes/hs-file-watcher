module Watcher.Parametros.Tests (test) where

import Test.Hspec
import Test.QuickCheck
import Data.Maybe

import Watcher.Watch
import Watcher.Filter
import Watcher.Action
import Watcher.Parametros
import Watcher.Arquivo

import Input.Parsers

command =
    ["C:\\Desenv\\",  "--print", "arquivoAlterado!", "--cmd", "dir", "--ed", ".stack-work", "--ef", "readme.md", "--only-extensions", "hs"]

commandOneArg =
    ["C:\\Desenv\\",  "--print", "arquivoAlterado!", "--ed", ".stack-work"]

test :: IO ()
test = hspec $ do
  describe "Modulo Parametros" $ do
    context "Directory Parser" $ do
      it "should return add a trailling \\ to derectory when needed" $ do
          parseDir (emptyParams, command) >>= Right . directory . fst
          `shouldBe` Right ("C:\\Desenv\\")

      it "should return the directory untouched when trailling \\ is already there" $ do
          parseDir (emptyParams, command) >>= Right . directory . fst
          `shouldBe` Right ("C:\\Desenv\\")

      it "should return a directory \".\" when no directory is supplied" $ do
          parseDir (emptyParams, drop 1 command) >>= Right . directory . fst
          `shouldBe` Right (".")

      it "should return the command untouched when there's no directory input" $ do
          parseDir (emptyParams, drop 1 command) >>= Right . snd
          `shouldBe` Right (drop 1 command)

    context "File Parser" $ do
      it "Should return a tuple (file, directory) when a file is received as Input" $ do
          parseFile "C:\\Desenv\\Prj\\File.hs"
          `shouldBe` ("File.hs","C:\\Desenv\\Prj\\")

      it "Should return a tuple (\"\", directory) when a directory is received as Input" $ do
          parseFile "C:\\Desenv\\Prj\\"
          `shouldBe` ("","C:\\Desenv\\Prj\\")

    context "Options Parser" $ do
        context "Filters" $ do
           it "should create a list with just one filter" $ do
               addOption'  emptyParams "--ed" [".stack-work"] >>= Right . filters
               `shouldBe` Right [excludeDirectories [".stack-work"]]

        context "Actions" $ do
           it "should create a list with just one Action"$ do
                addOption'  emptyParams "--p" ["arquivoAlterado!"] >>= Right . actions
               `shouldBe` Right [textAction ["arquivoAlterado!"]]

    context "Utils" $ do
      it "keyMatch should find the correct value from command map" $ do
          keyMatch "--ed" filtersList >>= \x -> Just $ x [".stack-work"]
          `shouldBe` Just (excludeDirectories [".stack-work"])

      it "keyMatch should find the correct value using the alternative option name" $ do
          keyMatch "--exclude-directories" filtersList >>= \x -> Just $ x [".stack-work"]
          `shouldBe` Just (excludeDirectories [".stack-work"])

      it "KeyMatch should return nothing when command does not exist" $ do
          keyMatch "-xxy" filtersList >>= \x -> Just $ x [".stack-work"]
          `shouldBe` Nothing

    context "Errors" $ do
      it "should return a message when input contains a command that doesnt exist" $ do
          parseParameters emptyParams ["C:\\Desenv\\",  "--prt", "arquivoAlterado!", "--ed", ".stack-work"]
          `shouldBe` Left ("O comando \'--prt\' nao existe!")

      it "should return a meessage when there's no actions defined on input" $ do
           parseParameters emptyParams (drop 3 commandOneArg)
           `shouldBe` Left "Não foram definidas acões!"
