import Text.ParserCombinators.Parsec
import Data.List

elfs :: GenParser Char st [Integer]
elfs = 
    do result <- many elf
       return (reverse . sort $ result)

elf :: GenParser Char st Integer
elf = 
    do c <- many1 calories
       eol
       return (sum c)

calories :: GenParser Char st Integer
calories = 
    do digits <- many1 digit
       eol
       let result = read digits :: Integer
       return result

eol :: GenParser Char st Char
eol = char '\n'

main :: IO()
main = do
    result <- parseFromFile elfs "input.txt"
    case result of
        Left err  -> print err
        Right xs  -> print (sum . take 1 $ xs, sum . take 3 $ xs)
