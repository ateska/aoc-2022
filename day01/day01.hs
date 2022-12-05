import Data.List
import Text.ParserCombinators.Parsec

elfs :: GenParser Char st [Integer]
elfs = 
    do result <- many elf
       return (reverse . sort $ result)

elf :: GenParser Char st Integer
elf = 
    do c <- many1 calories
       newline
       return (sum c)

calories :: GenParser Char st Integer
calories = 
    do digits <- many1 digit
       newline
       return (read digits :: Integer)

main :: IO()
main = do
    result <- parseFromFile elfs "input.txt"
    case result of
        Left err  -> print err
        Right xs  -> print (sum . take 1 $ xs, sum . take 3 $ xs)
