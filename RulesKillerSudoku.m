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
function [partialPuzzle, cages] = generateRandomKillerSudoku(solvedPuzzle)
    % Initialize variables
    partialPuzzle = zeros(9, 9);
    cells = 1:81;
    numCages = 10; % Number of cages
    cages = [];
    
     % Predefined list of colors in hexadecimal format
   colorPool = {
    '#FF0000',  % Red
    '#00FF00',  % Green
    '#0000FF',  % Blue
    '#FFFF00',  % Yellow
    '#FF00FF',  % Magenta
    '#00FFFF',  % Cyan
    '#FFA500',  % Orange
    '#800080',  % Purple
    '#fabed4',  % Pink
    '#9A6324'  % Brown
    
};
    
   % Extend and shuffle the color pool if necessary
    if numCages > length(colorPool)
        colorPool = repmat(colorPool, 1, ceil(numCages / length(colorPool)));
    end
    shuffledColors = colorPool(randperm(numCages));
    
    
    % Shuffle cells for random cage 
    cells = cells(randperm(length(cells)));
    
    % Distribute cells into cages
    for i = 1:numCages
        
        
        % Randomly decide the size of the cage
        cageSize = randi([2, min(3, length(cells))]);
        
        % Get the indices of the cells 
        cageCells = cells(1:cageSize);
        cells(1:cageSize) = [];  % Remove used cells
        
        % Convert linear indices to row, col pairs
        [rows, cols] = ind2sub([9, 9], cageCells);
        cellPositions = [rows', cols'];
        
        % Calculate the sum of the values 
        sumValue = sum(solvedPuzzle(sub2ind(size(solvedPuzzle), rows', cols')));
        
        % Assign a color from the shuffled list
        color = shuffledColors{i};
        
        % Store the cage information
        cages = [cages; struct('cells', cellPositions, 'sum', sumValue, 'color', color)];
        
        % Place the values in the partial puzzle for visual clarity
        for j = 1:fix(size(cellPositions, 1)/2)
            partialPuzzle(cellPositions(j, 1), cellPositions(j, 2)) = ...
                solvedPuzzle(cellPositions(j, 1), cellPositions(j, 2));
        end
    end
end



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

% Randomize the solved puzzle
solvedPuzzle = randomizeSolvedPuzzle(baseSolvedPuzzle);

% Generate a random Killer Sudoku puzzle with random colors
[partialPuzzle, cages] = generateRandomKillerSudoku(solvedPuzzle);

save RulesKillerSudoku.mat partialPuzzle solvedPuzzle cages

load('RulesKillerSudoku.mat')