classdef Gradients < matlab.mixin.SetGet
  properties
    W;
    V;
    U;

    b;
    c;
  end
  methods
    function obj = Gradients(W,V,U,b,c)
      obj.W = zeros(size(W));
      obj.V = zeros(size(V));
      obj.U = zeros(size(U));

      obj.b = zeros(size(b));
      obj.c = zeros(size(c));
    end
    function Zero()
      set(obj, 'W', zeros(size(obj.W)));
      set(obj, 'V', zeros(size(obj.V)));
      set(obj, 'U', zeros(size(obj.U)));

      set(obj, 'b', zeros(size(obj.b)));
      set(obj, 'c', zeros(size(obj.c)));
    end
  end
end
