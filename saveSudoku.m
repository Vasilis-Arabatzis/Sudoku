%% Automate Importing Data by Generating Code Using the Database Explorer App
% This code reproduces the data obtained using the Database Explorer app by
% connecting to a database, executing a SQL query, and importing data into the
% MATLAB(R) workspace. To use this code, add the password for connecting to the
% database in the database command.

% Auto-generated by MATLAB (R2024a) and Database Toolbox Version 24.1 on 07-Oct-2024 14:08:16

%% Make connection to database
conn = sqlite('sudoku.db');

%Set query to execute on the database
query = ['Insert into score (gameMode,winner, timer)Values("sudoku", "Zorushi23","1:10:23");' 
];

%% Execute query and fetch results
data = fetch(conn,query);

%% Close connection to database
close(conn)

%% Clear variables
clear conn query