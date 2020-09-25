function i = RouletteWheelSelection(p)

    r = 0.9;
    c = cumsum(p);
    i = find(r <= c, 1, 'first');

end