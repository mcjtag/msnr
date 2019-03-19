function [V,I]= extrem2(x, index, direction, type, n)

N = numel(x);

% Set direction
if strcmp(direction, 'right')
	dir = 1;
	end_index = N;
elseif strcmp(direction, 'left')
	dir = -1;
	end_index = 1;
else
	error('Invalid input argument ''direction''');
end

%Set type
if strcmp(type, 'max')
	t = 0;
elseif strcmp(type, 'min')
	t = 1;
else
	error('Invalid input argument ''type''');
end

% Set local
loc = [x(index) x(index) x(index)];
I = index;
ln = 0;
for i=index:dir:end_index
	loc = [loc(2) loc(3) x(i)]; 
	if t
		if (loc(1) > loc(2)) && (loc(2) < loc(3))
			ln = ln + 1;
			if ln >= n
				I = i - dir;
				break;
			end
		end
	else
		if (loc(1) < loc(2)) && (loc(2) > loc(3))
			ln = ln + 1;
			if ln >= n
				I = i - dir;
				break;
			end
		end
	end
end

V = x(I);

end