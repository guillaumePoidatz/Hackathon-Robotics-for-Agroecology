function state = momentMatching(ws, states)
  if length(ws) == 1
    state = states;
    return;
  end
  ws = exp(ws); % No choice here...
  wsum = sum(ws);

  H = size(states, 1);
  x_bar = zeros(size(states(1).x));
  P_bar = zeros(size(states(1).x, 1));
  for h = 1:H
    x_bar = x_bar + ws(h) * states(h).x;
  end

  % Need to use a second loop as x_bar is not fully computed until the end of the previous one
  for h = 1:H
    P_bar = P_bar + ws(h) * states(h).P + ws(h) * (x_bar - states(h).x) * (x_bar - states(h).x)';
  end

  state.x = x_bar / wsum;
  state.P = P_bar / wsum;
endfunction
