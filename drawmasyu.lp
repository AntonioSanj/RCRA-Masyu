#program display.
#const separ=30.
#const hmargin=15.
#const vmargin=15.

&display{window,h=H,w=W,caption="Masyu"} :- H=2*vmargin+separ*(n-1),W=2*hmargin+separ*(n-1).
_pos(0..n-1,0..n-1).
_ball(X,Y,0) :- black(K),Y=K/n,X=K\n.
_ball(X,Y,1) :- white(K),Y=K/n,X=K\n.
_point(X,Y,W,6) :- _ball(X,Y,W).
_point(X,Y,0,2) :- _pos(X,Y), not _ball(X,Y,_).

&display{circle,x=X,y=Y,r=R,color=black,width=W} 
  :- _point(X1,Y1,W,R), X=separ*X1+hmargin,Y=separ*Y1+vmargin.

&display{line,x1=X1,y1=Y1,x2=X2,y2=Y2,color=black,width=1} 
  :- seg(A,B),X1=separ*(A\n)+hmargin,Y1=separ*(A/n)+vmargin,
     X2=separ*(B\n)+hmargin,Y2=separ*(B/n)+vmargin.
