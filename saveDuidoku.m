
            dataPlayer = load("winner.mat");
            %% Make connection to database
            conn = sqlite('sudoku.db');
            if dataPlayer.draw == 0

                %Set query to execute on the database
                query = ['Insert into score (gameMode,winner, timer, loser ,draw)' ...
                    'Values("Duidoku", "' dataPlayer.winner '","' dataPlayer.time '", "' dataPlayer.loser '","Winner");' 
                ];
            else
                
                %Set query to execute on the database
                query = ['Insert into score (gameMode,winner, timer, loser , draw)' ...
                    'Values("Duidoku", "' dataPlayer.winner '","' dataPlayer.time '", "' dataPlayer.loser '"  ,"DRAW");' 
                ];

            end    
            %% Execute query and fetch results
            data = fetch(conn,query);
            
            %% Close connection to database
            close(conn)
            
            %% Clear variables
            clear conn query