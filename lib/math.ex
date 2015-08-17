defmodule Math do
  def vfun([a|b], fun) when is_function(fun, 1) do
    [fun.(a)|vfun(b,fun)]
  end
  def vfun([], fun) when is_function(fun, 1) do [] end

  def vfun([a|b], [c|d], fun) when is_function(fun, 2) do
    [fun.(a,c)|vfun(b,d,fun)]
  end
  def vfun([], [], fun) when is_function(fun, 2) do [] end


  def neg(a) do vfun(a, &(-&1)) end
  def add(a, b) do vfun(a, b, &(&1+&2)) end
  def sub(a, b) do vfun(a, b, &(&1-&2)) end
  def dir(src, dst) do sub(dst,src) |> clamp(-1,1) end

  def clamp(a, min, max) when is_list(a) do vfun(a, &clamp(&1, min, max)) end
  def clamp(a, min, max) when is_integer(a) do
    cond do
      a < min -> min
      a > max -> max
      true -> a
    end
  end

  def xor(a, b) do (a or b) and not (a and b) end
end
