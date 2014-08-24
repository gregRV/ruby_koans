# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
	# if a <= 0 || b <= 0 || c <= 0
	# 	raise TriangleError, "No side can be less than or equal to zero."
	# end

	if ((a+b) <= c) || ((a+c) <= b) || ((b+c) <= a)
		raise TriangleError, "No side can be greater than or equal to the sum of the other two."
	end

  # equilateral
  if a==b && a==c && b==c
  	return :equilateral
  end
  
  # isosceles
  if (a==b && a!=c) ||
  	 (a==c && a!=b) ||
  	 (b==c && a!=b)
  	 return :isosceles
  end

  # scalene
  if (a!=b && b!=c && a!=c)
  	return :scalene
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end


# MY NOTES
# All tests seem to pass even when I comment out my tests. I'm not sure if this is a bug,
# but before it would throw my error messages and now it doesn't seem to do anything at all.
# That aside, if I were to refactor this (and error handling is definitely something I need
# more practice with), I would extract the error logic out into its own method, provide it
# the args of #triangle to either validate that it's a legit triangle or throw the appropriate error.

# UPDATE
# It finally got to raise errors after the exercise about Exceptions, so now I'm back to updating this file.
# It was only needing the 2nd condition/exception I tested for, so I left the first commented out
# in the event that I'll need to return to this file again.