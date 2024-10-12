            dataPlayer = load("sudoku.mat");
            %% Make connection to database
            conn = sqlite('sudoku.db');
            

            %Set query to execute on the database
            query = ['Insert into score (gameMode,winner, timer )' ...
               'Values("KillerSudoku", "' dataPlayer.name '","' dataPlayer.time '");' 
            ];

             
            %% Execute query and fetch results
            data = fetch(conn,query);
            
            %% Close connection to database
            close(conn)
            
            %% Clear variables
            clear conn query