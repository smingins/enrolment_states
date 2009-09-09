module Enumerable
 # Like #first and #last, but raises an error if there's more than one item in
 # the collection.  Useful to make code that only makes sense if there's only
 # one of something "fail fast" without needing to repetitively assert this.
 def only
   raise "should only have one element out of #{inspect}" if size > 1
   first
 end
end