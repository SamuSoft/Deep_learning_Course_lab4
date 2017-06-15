classdef translator

  properties (GetAccess=private)
    char_to_ind_Map = containers.Map('KeyType','char','ValueType','int32');
    ind_to_char_Map = containers.Map('KeyType','int32','ValueType','char');
    K;
  end

  methods
    function obj = translator()
      [~, book_char] = obj.readData();
      obj.K = size(book_char,2);
      for i=1:obj.K
        obj.char_to_ind_Map(book_char(i)) = int32(i);
        obj.ind_to_char_Map(i) = book_char(i);
      end


    end

    function Data = ind_to_char(obj, input_value)
      for i = 1:size(input_value,2)
        [~,a] = max(input_value(:,i));
        char_list(i) = char(obj.ind_to_char_Map(a));
      end
      Data = char(char_list);
    end
    function Data = char_to_ind(obj, input_value)
      OneHot = squeeze(zeros(obj.K,size(input_value,2)));
      for i = 1:size(input_value,2)
        ind = obj.char_to_ind_Map(input_value(i));
        OneHot(ind,i) = 1;
      end
      Data = OneHot;
    end
  end
  methods (Static)
      function [book_data, book_char] = readData()
          book_fname = 'data/goblet_book.txt';
          fid = fopen(book_fname,'r');
          book_data = fscanf(fid,'%c');
          fclose(fid);
          book_char = unique(book_data);
      end
    end
end
