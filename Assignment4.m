
%
% char_to_ind = containers.Map('KeyType','char','ValueType','int32');
% ind_to_char = containers.Map('KeyType','int32','ValueType','char');
[book_data, book_char] = read_Data();
% for i = 1:size(book_char,2)
%   char_to_ind(book_char(i)) = i;
%   ind_to_char(i) = book_char(i);
% end
seqlength = 10000;
% seqlength = size(book_data,2)-1
Xchars = book_data(1:seqlength);
Ychars = book_data(2:seqlength+1);

trans = translator();

disp('Translating to OneHot');
X_chars = trans.char_to_ind(Xchars);
Y_chars = trans.char_to_ind(Ychars);



hidden_nodes = 5;
m = hidden_nodes;
eta = .1;
% seq_length = 25;


sig = 0.01;
K = size(book_char,2);
h0 = zeros(K,1);
%
% disp('Starting training');
RNN_model = RNN(m,K,sig);

Errors = RNN_model.testGradients(X_chars,Y_chars);

% h = zeros(100,1);
% for i = 1:10
%     disp(strcat('Trainingloop :', int2str(i)));
%     c = clock;
%     RNN_model.train(X_chars, Y_chars,h);
%     disp(clock - c);
% end

% a = RNN_model.synthesize(h,X_chars(:,1), 10);
% trans.ind_to_char(a);
