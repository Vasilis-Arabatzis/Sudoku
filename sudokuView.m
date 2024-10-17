             
            %% Make connection to database
            conn = sqlite('sudoku.db');


            %Set query to execute on the database
            query = ['SELECT winner,timer,gameMode FROM score WHERE gameMode = "sudoku";' 
            ];


            %% Execute query and fetch results
            dataS = fetch(conn,query);

            %% Save data to workspace

            save sudokuView.mat dataS;
            
            %% Close connection to database
            close(conn)

            %% Clear variables
            clear conn query