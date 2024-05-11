import pygame
import clingo
import sys

def convert_value(v):
    if v.type==clingo.TheoryTermType.Symbol:
        if v.name[0]=='"': return v.name[1:-1]
        return v.name
    if v.type==clingo.TheoryTermType.Number:
        return v.number
    return None

def concat_strings(list):
    s=""
    for x in list.arguments: s+=(convert_value(x).__str__())
    return s

# Input: a clingo TheoryTerm t
# Requires: the term must be a Function/Symbol or a pair attr=value
# Output: a pair (attr,val) where attr is a string and val a number or string
# Error: if the input is invalid, it returns None
def convert_term(t):
    if t.type==clingo.TheoryTermType.Symbol:
        return (t.name,True)
    if t.type==clingo.TheoryTermType.Function:
        if t.name!='=':
            return (t.__str__(),True)
        else:
            attr=t.arguments[0].__str__()
            value=t.arguments[1]
            if value.type in [clingo.TheoryTermType.List,clingo.TheoryTermType.Set,clingo.TheoryTermType.Tuple]:
                return(attr,concat_strings(value))
            value=convert_value(value)
            if value==None: return None          
            return (attr,value)
    return None

def windowdata(lits):
    params={'h':200,'w':400,'caption':''}
    for l in lits:
        for e in thatoms[l]:
            if e[0]=='window':
                for t in e[1:]:
                    if t[0] in params:
                        if type(t[1])==str:
                            params[t[0]]=t[1][1:-1]
                        else:
                            params[t[0]]=t[1]
                return params
    return params

def getvalue(dict,attr,default):
    if attr in dict: return dict[attr]
    return default

### Main program

if len(sys.argv)<2:
    print("display.py file1 [file2 ... ]")
    sys.exit()

# Loading files and grounding
ctl = clingo.Control()
ctl.add("base", [], "#theory disp {	attr_term { = : 0, binary, left };	&display /0 : attr_term, head}.")
for arg in sys.argv[1:]:
    ctl.load(arg)
ctl.ground([("base", []),("display",[])])

# Indexing theory atoms by their literal number
# Each theory atom is stored as a list of elements
# being each element is a dictionary (attribute_string,value)
thatoms = {}

for a in ctl.theory_atoms:
    elems=[]
    for e in a.elements:
        attrs={}
        for t in e.terms:
            t2=convert_term(t)
            if t2!=None:
                attrs[t2[0]]=t2[1]
        elems.append(attrs)
#    print(elems)
    thatoms[a.literal]=elems

# Solving    
models = []
with ctl.solve(yield_=True) as handle:
  for model in handle:
      #models.append(model.symbols(atoms=True))
      lits=[]
      for lit in thatoms:
          if model.is_true(lit):
              lits.append(lit)
      models.append(lits)

if len(models)==0:
    print("No answer sets")
    sys.exit()
lits=models[0]

# Search the first window element
win=None
for l in lits:
    for e in thatoms[l]:
       if 'window' in e:
           win=e
           break
    if win!=None: break 
h=getvalue(win,'h',200)
w=getvalue(win,'w',200)
cap=getvalue(win,'caption','')
bgcolor=getvalue(win,'bgcolor','white')
    
# Visualization

pygame.init()
screen = pygame.display.set_mode([w,h])
screen.fill(pygame.Color(bgcolor))
pygame.display.set_caption(cap)

defaultfontsize=20

#screen.blit(img, [0,0])
for l in lits:
    for e in thatoms[l]:
        if 'window' not in e:
            if 'image' in e:
                img = pygame.image.load(e['image']).convert()
                screen.blit(img, [e['x'],e['y']])
            elif 'text' in e:
                size=getvalue(e,'size',defaultfontsize)
                color=pygame.Color(getvalue(e,'color',"black"))
                font = pygame.font.Font(pygame.font.get_default_font(), size)
                if 'italic' in e: font.set_italic(True)
                if 'bold' in e: font.set_bold(True)
                if 'underline' in e: font.set_underline(True)
                text_surface = font.render(e['text'].__str__(), True,color)
                screen.blit(text_surface, dest=(e['x'],e['y']))
            elif 'line' in e:
                color=pygame.Color(getvalue(e,'color',"black"))
                width=getvalue(e,'width',10)
                pygame.draw.line(screen,color,(e['x1'],e['y1']),(e['x2'],e['y2']),width)
            elif 'rectangle' in e:
                color=pygame.Color(getvalue(e,'color',"black"))
                width=getvalue(e,'width',2)   # if width=0 then it will be filled
                pygame.draw.rect(screen,color,[e['x'],e['y'],e['w'],e['h']],width)
            elif 'circle' in e:
                color=pygame.Color(getvalue(e,'color',"black"))
                width=getvalue(e,'width',2)    # if width=0 then it will be filled
                pygame.draw.circle(screen,color,(e['x'],e['y']),e['r'],width)


pygame.display.flip()

done=False
while not done:
    for evento in pygame.event.get():
        if evento.type == pygame.QUIT:
            done = True
pygame.quit()
