module Watcher.Modificadores (delayM, modificadoresList) where

import Help.Command

delayM :: [String] -> Int
delayM x = read (head x)

modificadoresList :: [(Option, [String] -> Int)]
modificadoresList = [(Extended ["--d", "--delay"]
                      "Especifica a frequência das checagem por modificações (em segundos). Caso não seja informado, o valor default de 3 segundos será utilizado. Ex: hs-file-watcher --d 3"
                    , delayM )]