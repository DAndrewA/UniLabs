import time

def appendToFile(filename,text):
    f = open(filename,"a")
    timeStamp = time.asctime()
    f.write(timeStamp + ": " + text + "\n")
    f.close()

fName = input("What file would you like to edit? ")
print("To quit the program, type 'q'")
running = True
while running:
    logText = input("LOG: ")
    if logText != "q":
        appendToFile(fName,logText)
    else:
        running = False
    
