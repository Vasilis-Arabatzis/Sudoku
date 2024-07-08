% Define a base solved Sudoku puzzle
baseSolvedPuzzle = [
    5 3 4 6 7 8 9 1 2;
    6 7 2 1 9 5 3 4 8;
    1 9 8 3 4 2 5 6 7;
    8 5 9 7 6 1 4 2 3;
    4 2 6 8 5 3 7 9 1;
    7 1 3 9 2 4 8 5 6;
    9 6 1 5 3 7 2 8 4;
    2 8 7 4 1 9 6 3 5;
    3 4 5 2 8 6 1 7 9
];

% Randomize the base solved puzzle
solvedPuzzle = randomizeSolvedPuzzle(baseSolvedPuzzle);

% Generate a partially filled Sudoku puzzle
partialPuzzle = generatePartialSudoku(solvedPuzzle);

% Solve the partial puzzle
solution = solveSudoku(partialPuzzle);

disp('Solution:');
disp(solution);

% Function to randomize the solved Sudoku puzzle
function randomizedPuzzle = randomizeSolvedPuzzle(puzzle)
    randomizedPuzzle = puzzle;
    numSwaps = randi([5, 10]);  % Random number of swaps
    
    for i = 1:numSwaps
        switch randi([1, 4])
            case 1
                % Swap two rows within the same block
                block = randi([0, 2]);
                row1 = block * 3 + randi([1, 3]);
                row2 = block * 3 + randi([1, 3]);
                while row1 == row2
                    row2 = block * 3 + randi([1, 3]);
                end
                temp = randomizedPuzzle(row1, :);
                randomizedPuzzle(row1, :) = randomizedPuzzle(row2, :);
                randomizedPuzzle(row2, :) = temp;
            case 2
                % Swap two columns within the same block
                block = randi([0, 2]);
                col1 = block * 3 + randi([1, 3]);
                col2 = block * 3 + randi([1, 3]);
                while col1 == col2
                    col2 = block * 3 + randi([1, 3]);
                end
                temp = randomizedPuzzle(:, col1);
                randomizedPuzzle(:, col1) = randomizedPuzzle(:, col2);
                randomizedPuzzle(:, col2) = temp;
            case 3
                % Swap two row blocks
                block1 = randi([0, 2]);
                block2 = randi([0, 2]);
                while block1 == block2
                    block2 = randi([0, 2]);
                end
                rows1 = (block1 * 3 + 1):(block1 * 3 + 3);
                rows2 = (block2 * 3 + 1):(block2 * 3 + 3);
                temp = randomizedPuzzle(rows1, :);
                randomizedPuzzle(rows1, :) = randomizedPuzzle(rows2, :);
                randomizedPuzzle(rows2, :) = temp;
            case 4
                % Swap two column blocks
                block1 = randi([0, 2]);
                block2 = randi([0, 2]);
                while block1 == block2
                    block2 = randi([0, 2]);
                end
                cols1 = (block1 * 3 + 1):(block1 * 3 + 3);
                cols2 = (block2 * 3 + 1):(block2 * 3 + 3);
                temp = randomizedPuzzle(:, cols1);
                randomizedPuzzle(:, cols1) = randomizedPuzzle(:, cols2);
                randomizedPuzzle(:, cols2) = temp;
        end
    end
end

% Function to generate a partially filled Sudoku puzzle from a solved puzzle
function partialPuzzle = generatePartialSudoku(solvedPuzzle)
    % Randomly choose cells to fill
    numCellsToFill = randi([30, 40]);  % Choose a random number of cells to fill
    filledCells = zeros(9);
    
    % Randomly choose positions to fill until we have numCellsToFill filled
    indices = randperm(81, numCellsToFill);
    
    for i = 1:numCellsToFill
        % Calculate row and column from the index
        row = ceil(indices(i) / 9);
        col = mod(indices(i) - 1, 9) + 1;
        
        filledCells(row, col) = solvedPuzzle(row, col);
    end

    % The filled cells will be the partial puzzle
    partialPuzzle = filledCells;
end

% Function to check if a Sudoku move is valid
function valid = isValidMove(puzzle, row, col, num)
    % Check if the number is already in the row
    if any(puzzle(row, :) == num)
        valid = false;
        return;
    end
    
    % Check if the number is already in the column
    if any(puzzle(:, col) == num)
        valid = false;
        return;
    end
    
    % Check if the number is already in the 3x3 subgrid
    startRow = 3 * floor((row - 1) / 3) + 1;
    startCol = 3 * floor((col - 1) / 3) + 1;
    subgrid = puzzle(startRow:startRow+2, startCol:startCol+2);
    if any(subgrid(:) == num)
        valid = false;
        return;
    end
    
    % If the number doesn't violate any Sudoku rules, it's a valid move
    valid = true;
end

% Function to solve a Sudoku puzzle
function solution = solveSudoku(puzzle)
    % Find empty cells
    [row, col] = find(puzzle == 0);
    
    % If no empty cells are found, the puzzle is solved
    if isempty(row)
        solution = puzzle;
        return;
    end
    
    % Try numbers 1 to 9
    for num = 1:9
        if isValidMove(puzzle, row(1), col(1), num)
            % Make the move
            puzzle(row(1), col(1)) = num;
            
            % Recursively solve the puzzle
            solution = solveSudoku(puzzle);
            
            % If a solution is found, return it
            if ~isempty(solution)
                return;
            end
            
            % If no solution is found, backtrack
            puzzle(row(1), col(1)) = 0;
        end
    end
    
    % If no solution is found, return an empty matrix
    solution = [];
end

save RulesSudoku.mat partialPuzzle solution

           
 