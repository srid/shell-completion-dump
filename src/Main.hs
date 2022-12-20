module Main where

import Main.Utf8 qualified as Utf8
import Options.Applicative

data Sample
  = Hello [String]
  | Goodbye
  deriving stock (Eq, Show)

hello :: Parser Sample
hello = Hello <$> many (argument str (metavar "TARGET..."))

sample :: Parser Sample
sample =
  subparser
    ( command "hello" (info hello (progDesc "Print greeting"))
        <> command "goodbye" (info (pure Goodbye) (progDesc "Say goodbye"))
    )

main :: IO ()
main = do
  Utf8.withUtf8 $ do
    execParser (info sample idm) >>= \case
      Hello targets -> mapM_ putStrLn targets
      Goodbye -> putStrLn "Goodbye!"
