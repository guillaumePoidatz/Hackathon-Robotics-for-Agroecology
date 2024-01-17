function value = GOSPA(x, y, c)
  %%% Computes the GOSPA between the matrices x and y (representing sets) using threshold c on euclidian distance
  %% - x matrix of size (2, nb_x)
  %% - y matrix of size (2, nb_y)
  %% - c scalar
  %%
  %%% Returns the value of the gospa

  if size(x, 2) == 0
    value = c / 2 * size(y, 2);
    return;
  end
  if size(y, 2) == 0
    value = c / 2 * size(x, 2);
    return;
  end

  % Create the cost matrix using the euclidian distance
  D = zeros(size(x, 2), size(y, 2));

  for i = 1:size(x, 2)
    xi = x(:, i);
    for j = 1:size(y, 2)
      yj = y(:, j);
      % Compute the euclidian distance
      d = sqrt((xi(1) - yj(1))^2 + (xi(2) - yj(2))^2);

      % If it is > than c, then the association is not possible
      if d > c
        d = Inf;
      end
      D(i, j) = d;
    end
  end

  % Using this cost matrix, get the best assignment possible
  [assign, cost] = ref.munkres(D);

  % The association cost is the sum of the distance of associated elements
  value = cost;
  % The elements from x that are not associated are the zeros of the assign vector
  value = value + c / 2 * sum(assign == 0);
  % The number of unassociated elements from y is the size of y minus the number of nonzero elements
  value = value + c / 2 * (size(y, 2) - sum(assign ~= 0));
end
