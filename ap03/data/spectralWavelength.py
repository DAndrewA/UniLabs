def spectralWavelength(channel,splitChar):
    # opens text file for given spectral response
    filename = "ch" + str(channel) + ".txt"
    f = open(filename,'r')
    contents = f.read()
    f.close()

    # splits file into each row of data
    contents = contents.split("\n")
    contents = contents[6:]

    spectralResponse = 0
    normalisation = 0
    for row in contents:
        try:
            splitRow = row.split(splitChar)
            spectralResponse += float(splitRow[0])*float(splitRow[1])
            normalisation += float(splitRow[1])
        except:
            print("Problem with line reading: " + str(row))

    wavelength = spectralResponse/normalisation
    return wavelength

print("9: " + str(spectralWavelength(9," ")))
print("10: " + str(spectralWavelength(10,"	")))
    
