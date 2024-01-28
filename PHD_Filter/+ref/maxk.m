%{
 Copyright (C) 2021 matilde-t
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{[val, idx]} =} maxk (@var{A}, @var{k})
##
## Find @var{k} largest elements of @var{A}
##
## If @var{k} equals the size of @var{A}, it sorts the elements in descending order
##
## If @var{A} is a matrix, maxk is applied column-wise
##
## @seealso{max}
## @end deftypefn

## Author: matilde-t <github.com/matilde-t>
## Created: 2021-09-09
%}
function [val, idx] = maxk (A, k)
  if min(size(A))~=1
    val = zeros(k,size(A,2));
    idx = zeros(k,size(A,2));
    for i = 1:size(A,2)
      [val(:,i), idx(:,i)] = maxk(A(:,i),k);
    end
  else
    if k > max(size(A))
      printf("error: number of elements exceeds size of array\n")
      return
    end
    for i = 1:k
      [val(i), idx(i)] = max (A);
      A(idx(i)) =-Inf;
    end
  end
end
