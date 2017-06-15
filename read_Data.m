function [book_data, book_char] = readData()
  book_fname = 'data/goblet_book.txt';
  fid = fopen(book_fname,'r');
  book_data = fscanf(fid,'%c');
  fclose(fid);
  book_char = unique(book_data);
end
