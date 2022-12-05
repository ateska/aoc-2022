import Text.Parsec
import Text.Parsec.Text

ranges = many1 rangeline

rangeline = do
    r1a <- digits
    char '-'
    r1b <- digits
    char ','
    r2a <- digits
    char '-'
    r2b <- digits
    newline
    return (read r1a :: Integer, read r1b :: Integer, read r2a :: Integer, read r2b :: Integer)

digits = many1 digit

score1 :: (Integer, Integer, Integer, Integer) -> Integer
score1 (r1a, r1b, r2a, r2b) = 
    if ((r1a <= r2a) && (r1b >= r2b)) then  1
    else if ((r2a <= r1a) && (r2b >= r1b)) then  1
    else 0

score2 :: (Integer, Integer, Integer, Integer) -> Integer
score2 (r1a, r1b, r2a, r2b) = 
    if (r1b < r2a) then  0
    else if (r1a > r2b) then  0
    else 1

main :: IO()
main = do
    result <- parseFromFile ranges "input.txt"
    case result of
        Left err  -> print err
        Right xs  -> print (sum ( map score1 xs ), sum ( map score2 xs ))
