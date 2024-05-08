import sys

def printlist(name,l):
    if l==[]:
        return
    print(f"{name}(", end='')
    for i in range(0,len(l)-1):
        print(l[i],end='')
        print(";",end='')
    print(l[-1],end='')
    print(").")

if len(sys.argv)!=3:
    print("encode.py inputfile outputfile")
    sys.exit()

f = open(sys.argv[1], "r")
out = open(sys.argv[2], "w")
sys.stdout = out
n=0
i=0
blacks=[]
whites=[]
for line in f:
    l = line.split()
    if n==0:
        n=len(l)
    j=0
    for c in l:
        if c=='0':
            whites.append(i)
        elif c=='1':
            blacks.append(i)
        i=i+1
print(f"#const n={n}.")
printlist("black",blacks)
printlist("white",whites)
f.close()
out.close()