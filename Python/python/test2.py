def func1(cc):
    print 'this is func1'
    print '2'
    return cc

def func2(dd):
    print 'this is func2'
    return dd

@func1
@func2
#add = func2(add)
def add():
    print "this is add"	

add()
