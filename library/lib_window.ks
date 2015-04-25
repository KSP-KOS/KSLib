

@lazyglobal off.

function create_window{
	parameter x,y,w,h.
	// w and h are INTERNAL width and height
	local eq_str is "+".
	local space_str is "|".
	local i is 0.
	until i=w{
		set eq_str to eq_str+"=".
		set space_str to space_str+" ".
		set i to i+1.
	}
	set eq_str to eq_str+"+".
	set space_str to space_str+"|".
	print eq_str at(x,y).
	print eq_str at(x,y+h+1).
	set i to 0.
	until i=h{
		print space_str at(x,y+i+1).
		set i to i+1.
	}
	return list(x,y,w,h). //returning list as a window handle
}
