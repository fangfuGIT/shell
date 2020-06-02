def log(func):
    def inner(*args, **kw):
    	print 'log %s():' % func.__name__
    	return func(*args, **kw)
    return inner
@log
def f():
    print '2018-03-05'

f()
