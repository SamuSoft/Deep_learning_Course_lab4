char_to_ind = containers.Map(’KeyType’,’char’,’ValueType’,’int32’);
ind_to_char = containers.Map(’KeyType’,’int32’,’ValueType’,’char’);

[book_data, book_char] = readData();

hidden_nodes = 100;
m = hidden_nodes;
eta = .1;
seq_length = 25;

% for i = 1:size(book_char)
char_to_ind = containers.Map(book_char, [1:size(book_char)]);
ind_to_char = containers.Map([1:size(book_char)], book_char);
