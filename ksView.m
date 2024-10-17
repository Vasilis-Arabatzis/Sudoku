            %% Make connection to database
            conn = sqlite('sudoku.db');


            %Set query to execute on the database
            query = ['SELECT winner,timer,gameMode FROM score WHERE gameMode = "KillerSudoku";' 
            ];

            %% Execute query and fetch results
            dataKS = fetch(conn,query);

            %% Save data to workspace

            save KillerSudokuView.mat dataKS;

            %% Close connection to database
            close(conn)

            %% Clear variables
            clear conn query 