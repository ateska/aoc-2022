import Text.Parsec
import Text.Parsec.Text

draws = many1 draw

draw = do
    opp <- letter
    space
    me <- letter
    newline
    return (opp, me)

score1 :: (Char,Char) -> Int
score1 (opp, me) = case (opp, me) of
    ('A', 'X') -> 3 + 1 -- We play Rock - draw
    ('A', 'Y') -> 6 + 2 -- We play Paper - win
    ('A', 'Z') -> 0 + 3 -- We play Scisor - loss
    ('B', 'X') -> 0 + 1 -- We play Rock - loss
    ('B', 'Y') -> 3 + 2 -- We play Paper - draw
    ('B', 'Z') -> 6 + 3 -- We play Scisor - win
    ('C', 'X') -> 6 + 1 -- We play Rock - win
    ('C', 'Y') -> 0 + 2 -- We play Paper - loss
    ('C', 'Z') -> 3 + 3 -- We play Scisor - draw

score2 :: (Char,Char) -> Int
score2 (opp, me) = case (opp, me) of
    ('A', 'X') -> 0 + 3 -- We need to lose -> scissors
    ('A', 'Y') -> 3 + 1 -- We need to draw -> rock
    ('A', 'Z') -> 6 + 2 -- We need to win -> paper
    ('B', 'X') -> 0 + 1 -- We need to lose -> rock
    ('B', 'Y') -> 3 + 2 -- We need to draw -> paper
    ('B', 'Z') -> 6 + 3 -- We need to win -> scissors
    ('C', 'X') -> 0 + 2 -- We need to lose -> paper
    ('C', 'Y') -> 3 + 3 -- We need to draw -> scissors
    ('C', 'Z') -> 6 + 1 -- We need to win -> rock

main :: IO()
main = do
    result <- parseFromFile draws "input.txt"
    case result of
        Left err  -> print err
        Right xs  -> print (sum (map score1 xs), sum (map score2 xs))
