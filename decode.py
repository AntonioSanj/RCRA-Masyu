import clingo
import sys

### Main program

if len(sys.argv)<2:
    print("decode.py file1 [file2 ... ]")
    sys.exit()

# Loading files and grounding
ctl = clingo.Control()
ctl.add("base", [], "size(n).")
for arg in sys.argv[1:]:
    ctl.load(arg)
ctl.ground([("base", [])])
ctl.configuration.solve.models="0"

# Solving    
size=0
with ctl.solve(yield_=True) as handle:
  for model in handle:
      edges=[]
      blacks=[]
      whites=[]
      for atom in model.symbols(atoms=True):
          if (atom.name=="size" 
          and len(atom.arguments)==1 
          and atom.arguments[0].type is clingo.SymbolType.Number):
            size=atom.arguments[0].number
          elif (atom.name=="seg"
          and len(atom.arguments)==2):
              edges.append((atom.arguments[0].number,atom.arguments[1].number))
          elif (atom.name=="black"
          and len(atom.arguments)==1):
              blacks.append(atom.arguments[0].number)
          elif (atom.name=="white"
          and len(atom.arguments)==1):
              whites.append(atom.arguments[0].number)
      a=[]
      for i in range(size):
        a.append( ['.',' ']*(size-1)+['.'])
        if i<size-1:
           a.append([' ']*(2*size+1) )
      for p in blacks:
         x1,y1=p // size, p % size
         a[2*x1][2*y1]='1'
      for p in whites:
         x1,y1=p // size, p % size
         a[2*x1][2*y1]='0'
      for e in edges:
         x1,y1=e[0] // size, e[0] % size
         x2,y2=e[1] // size, e[1] % size
         if x1==x2:  # horizontal line
            a[2*x1][2*y1+1]='-'
         else:
            a[2*x1+1][2*y1]='|'
      for line in a:
         for el in line:
            print(el,end='')
         print()
        
      print("----------")


