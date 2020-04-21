

def retry(n):
    def decorator(fn):
        def mod_fn(self, *args):
            for i in range(n):
                try:
                    ret_val = fn(args)
                except Exception as e:
                    print(e)
                else:
                    
                    break
            else:
                raise e
            return ret_val
        return mod_fn
    return decorator


foo = 0

@retry(3)
# fn1 is a function which we want should retry before giving up
def fn1(nv):
    global foo   
    foo += 1
    if foo < 5:
        raise Exception("retry")
    return 0

if __name__ == "__main__":
    try:
        fn1("hw")
    except Exception as e:
        print("foo failed")
        print("Faile with retry")



