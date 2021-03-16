ga = [52.083,51.456,51.604,51.987,51.964]
dga = [0.289,0.799,0.398,0.339,0.801]

gb = [54.334,52.380,52.415,52.541,52.376]
dgb = [2.882,0.699,0.303,0.254,0.627]

def weightedMean(data,error):
    mError = 0
    mean = 0
    for i in range(len(error)):
        mError += 1/(error[i]**2)
        mean += data[i]/(error[i]**2)
    mean = mean/mError
    mError = mError**(-0.5)

    return mean, mError

print(weightedMean(gb,dgb))


        
