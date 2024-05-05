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
print("HEY")
n=0
i=0
blacks=[]
whites=[]
for line in sys.stdin:
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