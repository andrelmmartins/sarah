module Avaliacao where

import System.IO

escreverAvaliacao::String -> IO()
escreverAvaliacao  avaliacao = do
    appendFile "../db/avaliacoes.txt" ( avaliacao ++ "\n")
    return ()

listaDeAvaliacoes ::  IO()
listaDeAvaliacoes  = do
    handle <- openFile "../db/medicos.txt" ReadMode  
    contents <- hGetContents handle
    putStr  contents
    hClose handle