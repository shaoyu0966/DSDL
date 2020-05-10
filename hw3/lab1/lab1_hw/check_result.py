import pandas as pd

df = pd.read_csv('result', sep=" / ", header=0, engine='python', dtype={'time':int, 'a':str, 'b':str, 'c0':str, 'c3_s':str, 'gl':str})
time = df['time']
a = df['a']
b = df['b']
c0 = df['c0']
c3_s = df['c3_s']
gl = df['gl']

prev_t = 0
for i in range(df.shape[0]-1):
    if c3_s[i] != gl[i] and time[i+1] - time[i] > 50:
        print(time[i], c3_s[i], gl[i])
    prev_t = time[i]
