import time
from threading import Thread

def timed(dur):
    def decorator(fn):
        def mod_fn(self, *args):
            var = "_"+getattr(fn, '__name__')+'_st'
            if not hasattr(self, var):
                setattr(self, var, time.time())
            last_ts = getattr(self, var)
            if time.time() - last_ts > dur:
                fn(self, args)
                setattr(self, var, time.time())
        return mod_fn
    return decorator

class foo:
    def __init__(self, name):
        self.name =name 

    @timed(5)
    def fn1(self, ns):
        print(f"Cur_time={time.time()}, ns={ns}, name={self.name}")


def target_fn(foo_inst):
    for i in range(20):
        print(i)
        foo_inst.fn1("target_fn"+str(i))
        time.sleep(1)

foo1 = foo("shashi")
foo2 = foo("banger")
t = Thread(target=target_fn, args=(foo1,))
t.start()


t = Thread(target=target_fn, args=(foo2,))
t.start()

time.sleep(30)

