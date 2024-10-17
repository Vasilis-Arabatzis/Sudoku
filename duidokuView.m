            %% Make connection to database
            conn = sqlite('sudoku.db');


            %Set query to execute on the database
            query = ['SELECT winner,timer,gameMode FROM score WHERE gameMode = "Duidoku";' 
            ];


            %% Execute query and fetch results
            dataDui = fetch(conn,query);

            %% Save data to workspace
            save duidokuView.mat dataDui;

            %% Close connection to database
            close(conn)

            %% Clear variables
            clear conn query
   