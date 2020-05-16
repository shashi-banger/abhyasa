import pandas as pd

df = pd.DataFrame({
    'length': [1.5, 0.5, 1.2, 0.9, 3],
    'width': [0.7, 0.2, 0.15, 0.2, 1.1]
    }, index=['pig', 'rabbit', 'duck', 'chicken', 'horse'])


p = dict(pd.qcut(df.length, 3))

print(p)

out = {}
for k in p.keys():
    if p[k] in out:
        out[p[k]].append(k)
    else:
        out[p[k]] = [k]

print(out)

