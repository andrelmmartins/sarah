module Avaliacao where

import System.IO

escreverAvaliacao::String -> IO()
escreverAvaliacao  avaliacao = do
    appendFile "../db/avaliacoes.txt" ( avaliacao ++ "\n")
    return ()

listaDeAvaliacoes ::  IO()
listaDeAvaliacoes  = do
    handle <- openFile "../db/avaliacoes.txt" ReadMode  
    contents <- hGetContents handle
    putStr  contents
    hClose handle

menuEscreverAvaliacao:: IO()
menuEscreverAvaliacao = do
    putStrLn "Conta pra gente o que achou da sua experiencia no SARAH!"
    putStrLn "Sua opiniao e sempre bem vinda"
    avaliacao <- getLine
    escreverAvaliacao avaliacao