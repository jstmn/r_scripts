
import time
q = [-1,-1,-1,-1,0]

def get_next(i):
    return (i % 4) + 1
    
def any_two_equal_1(q):
    return any(q.count(x) > 1 for x in q)

def any_two_equal_2(q):
	if q[0] == q[1] or q[0] == q[2] or q[0] == q[3]:
		return True
	if q[1] == q[2] or q[1] == q[3]:
		return True
	if q[2] == q[3]:
		return True
	return False


set_ = {"a":1,"b":2}

def get_key_from_set_1(q):
	if q in set_:
		return set_[q]
	return None

def get_key_from_set_2(q):
	try:
	    return set_[q]
	except KeyError:
	    return False





t_start = time.time()
runs = 100000
for i in range(runs):
	#any_two_equal_1(q)
	#any_two_equal_1([0,2,4,14])
	for x in ["a","b","c"]:
		get_key_from_set_1(x)

runtime = time.time() - t_start
print "ran:",runs,"trials w/ any_two_equal_1 in:",runtime,"s"


t_start = time.time()
for i in range(runs):
	#any_two_equal_2(q)
	#any_two_equal_2([0,2,4,14])
	for x in ["a","b","c"]:
		get_key_from_set_2(x)

runtime = time.time() - t_start
print "ran:",runs,"trials w/ any_two_equal_2 in:",runtime,"s"

