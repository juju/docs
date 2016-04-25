#!/usr/bin/env python

infile=open("./nav.txt","r")
outfile=open("../src/navigation.tpl","w")

#line parsing nav template => html. made complicated by randomness of how things are ordered

pre="<ul>\n"
expand='<li class="section"><a class="header" href="'
section='<li class="section"><h4 class="header toggle-target">'
sp="                                                           "
level=0
subflag = False
secflag = False


outfile.write(sp[:level*4]+pre)
for line in infile:
    if (line[:1]=='>'):
        #Section start
        if subflag:
          subflag = False
          level -= 1
          outfile.write(sp[:level*4]+'</ul>\n')
          level -= 1
          outfile.write(sp[:level*4]+'</li>\n')
        if secflag:
          level -= 1
          outfile.write(sp[:level*4]+'</ul>\n')
          level -= 1
        outfile.write("<!--- SECTION --->\n")
        secflag = True
        level=1
        outfile.write(sp[:level*4]+section+line[1:-1]+'</h4>\n')
        level += 1
        outfile.write(sp[:level*4]+'<ul>\n')
    elif (line[:1]=='+'):
        #expandable section
        o=line[1:].split('@')
        if subflag:
          level -=1
          outfile.write(sp[:level*4]+'</ul>\n')
          level -=1               
          outfile.write(sp[:level*4]+'</li>\n')
        outfile.write(sp[:level*4]+expand+o[0]+'">'+o[1][:-1]+'</a>\n')
        level +=1
        outfile.write(sp[:level*4]+'<ul class="sub">\n')
        level +=1
        subflag = True
    elif (line[:2]=='--'):
        o=line[2:].split('@')
        outfile.write(sp[:level*4]+'<li><a href="'+o[0]+'">'+o[1][:-1]+'</a></li>\n') 
    elif (line[:1]=='#'):
        # comments
        pass
    elif (line[:1]=='-'):
        if subflag:
          subflag= False
          level -= 1
          outfile.write(sp[:level*4]+'</ul>\n')
          level -= 1
          outfile.write(sp[:level*4]+'</li>\n')
        o=line[1:].split('@')
        outfile.write(sp[:level*4]+'<li><a href="'+o[0]+'">'+o[1][:-1]+'</a></li>\n')  
    elif (line[:1]=='') | (line[:1]=='\n'):
        # formatting chaff, do nothing
        pass
    else:
        # line on its own - probably the bottom
        if subflag:
          subflag= False
          level -= 1
          outfile.write(sp[:level*4]+'</ul>\n')
          level -= 1
          outfile.write(sp[:level*4]+'</li>\n')
        if secflag:
          level -= 1
          outfile.write(sp[:level*4]+'</ul>\n')
          level -= 1
          secflag = False
        level=0
        o=line.split('@')
        outfile.write(sp[:level*4]+'<li><a href="'+o[0]+'">'+o[1][:-1]+'</a></li>\n') 
outfile.write(sp[:level*4]+'</ul>\n')
outfile.close()
infile.close()
