function objects = estimates(ws, hyps)
  %%% Returns point estimates of the positions (x, y) of the targets
  %% - ws log weights of the hypotheses in the filter
  %% - hyps the hypotheses of the filter, struct array with fields x and P
  %%% Returns
  %% Estimates as a matrix of size (2, n) where n is the estimated number of targets.
  %%
  %% WARNING !! Note that we only return the positions (x, y) of the targets, not the other variables of the state vectors

  objects = ...;
endfunction
