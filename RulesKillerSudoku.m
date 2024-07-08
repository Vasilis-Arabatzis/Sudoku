% Generate a KillerSudoku grid
grid = solvedKillerSudoku();

% Generate cages based on the KillerSudoku grid
cages = generateCages(grid);

% Choose a random number of cells to fill
numCellsToFill = randi([30, 40]);  

% Generate puzzle based on the KillerSudoku grid
puzzle = FillRandomCells(grid, numCellsToFill);

function grid = solvedKillerSudoku()
    % Create an empty 9x9 Sudoku grid
    grid = zeros(9, 9);
    % Fill the grid using the backtracking algorithm
    grid = fillGrid(grid);

    
end

function grid = fillGrid(grid)
    % Find the next empty cell (cell with value 0)
    emptyCell = find(grid == 0, 1);
    % If there are no empty cells, the grid is fully filled
    if isempty(emptyCell)
        return;
    end
    % Convert linear index to row and column indices
    [row, col] = ind2sub(size(grid), emptyCell);

    % Shuffle numbers 1-9 to ensure randomness
    numbers = randperm(9);
    for num = numbers
        % Check if the number is valid for the current cell
        if isValid(grid, row, col, num)
            % Place the number in the cell
            grid(row, col) = num;
            % Recursively fill the rest of the grid
            grid = fillGrid(grid);
            % If the grid is fully filled, return the grid
            if all(grid(:) ~= 0)
                return;
            end
            % If not, backtrack by resetting the cell to 0
            grid(row, col) = 0;
        end
    end
end

function isValid = isValid(grid, row, col, num)
    % Check if the number is already in the current row, column, or 3x3 subgrid
    isValid = ~ismember(num, grid(row, :)) && ...
              ~ismember(num, grid(:, col)) && ...
              ~ismember(num, grid(3*floor((row-1)/3) + 1:3*floor((row-1)/3) + 3, 3*floor((col-1)/3) + 1:3*floor((col-1)/3) + 3));
end

function cages = generateCages(grid)
    % Randomly order the cells in the grid
    cells = randperm(81);
    % Create a logical matrix to keep track of visited cells
    visited = false(9, 9);
    cages = [];
    cageIndex = 1;

    % Continue until all cells have been visited
    while any(~visited(:))
        % Get the first unvisited cell
        currentCell = cells(find(~visited(cells), 1));
        [r, c] = ind2sub([9, 9], currentCell);
        cageCells = [];
        cageSum = 0;

        % Create a cage with a minimum sum and size constraints
        while cageSum < 10 || length(cageCells) < 2
            % Add the current cell to the cage
            cageCells(end+1) = sub2ind([9, 9], r, c);
            
            visited(r, c) = true;
            cageSum = sum(grid(cageCells));

            % Get neighboring cells that haven't been visited
            neighbors = getNeighbors(r, c, visited);
            if isempty(neighbors)
                break;
            end
            % Select a random neighbor to continue building the cage
            nextCell = neighbors(randi(length(neighbors)));
            [r, c] = ind2sub([9, 9], nextCell);
        end

        % Store the cage information
        cages(cageIndex).cells = cageCells;
        cages(cageIndex).sum = cageSum;
        cageIndex = cageIndex + 1;
    end
end

function neighbors = getNeighbors(r, c, visited)
    % Define potential neighboring cells (up, down, left, right)
    potentialNeighbors = [r-1 c; r+1 c; r c-1; r c+1];
    % Keep only valid neighbors within grid bounds
    validNeighbors = potentialNeighbors(all(potentialNeighbors > 0 & potentialNeighbors <= 9, 2), :);
    % Return indices of unvisited valid neighbors
    neighbors = sub2ind([9, 9], validNeighbors(~visited(sub2ind([9, 9], validNeighbors(:,1), validNeighbors(:,2))),1), validNeighbors(~visited(sub2ind([9, 9], validNeighbors(:,1), validNeighbors(:,2))),2));
end

function puzzle = FillRandomCells(grid, numCellsToExtract)
    % Initialize extracted grid with zeros
    puzzle = zeros(size(grid));

    % Get indices of filled cells in the original grid
    [filledRows, filledCols] = find(grid ~= 0);
    numFilledCells = numel(filledRows);

    % Randomly select indices to extract
    if numCellsToExtract > numFilledCells
        error('Number of cells to extract exceeds number of filled cells.');
    end
    
    % Randomly permute indices of filled cells
    permutedIndices = randperm(numFilledCells, numCellsToExtract);
    
    % Copy selected cells from original grid to extracted grid
    for i = 1:numCellsToExtract
        row = filledRows(permutedIndices(i));
        col = filledCols(permutedIndices(i));
        puzzle(row, col) = grid(row, col);
    end
end


save RulesKillerSudoku.mat puzzle grid cages
