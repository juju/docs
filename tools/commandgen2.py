#!/usr/bin/env python

import subprocess
import re
import codecs

outfile = codecs.open('commands.md','w', 'utf-8')

# useful text
pad=u'   '
pagetext=(u"Title:Juju commands and usage\n\n"
          "# Juju Command reference\n\n"
          "You can get a list of the currently used commands by entering\n" 
          "```juju help commands``` from the commandline. The currently"
          " understood commands\nare listed here, with usage and examples.\n\n"
          "Click on the expander to see details for each command. \n\n")



outfile.write(pagetext)
commands = subprocess.check_output(['juju', 'help', 'commands']).splitlines()

for c in commands:
    
    header = '^# '+str(c.split()[0])+ '\n\n'
    htext = subprocess.check_output(['juju', 'help', c.split()[0].decode('unicode_escape')])
    #p = re.compile(u'Usage:(.+?)\n\nSummary:\n(.+?)\n\nOptions:\n(.+?)Details:\n(.+)', re.DOTALL)
    #h=re.findall(p, htext.decode('unicode_escape'))
    
    # search for Aliases section
    # if it exists, truncate details and process
    q= re.compile(u'Aliases: ?(.+?)$',re.DOTALL | re.IGNORECASE)
    x = re.search( q, htext)
    if x:
      match=htext[x.start()+8:].split(' ')
      htext=htext[:x.start()] # truncate the bit we matched
      alias=pad+'**Aliases:**\n\n'
      for line in match:
        if (line !=''):
          alias = alias+pad+'_'+line.strip()+'_\n\n'
    else:
      alias=u''
 
    # search for see also section
    # if it exists, truncate details and process
    q= re.compile(u'See also: ?(.+?)$',re.DOTALL | re.IGNORECASE)
    x = re.search( q, htext)
    if x:
      match=htext[x.start()+11:].split('\n')
      htext=htext[:x.start()] # truncate the bit we matched
      also=pad+'**See also:**\n\n'
      
      for line in match:
        if (line !=''):
          
          also = also+pad+'['+line.strip()+'](#'+line.strip()+')\n\n'
    else:
      also=u''    

    # search for Examples section
    # if it exists, truncate details and process
    q= re.compile(u'Examples: ?\n(.+?)$',re.DOTALL)
    x = re.search( q, htext)
    if x:
      match=htext[x.start()+10:].split('\n')
      htext=htext[:x.start()] # truncate the bit we matched
      examples=pad+'**Examples:**\n\n'
      xflag = False
      for line in match:
        if (line !=''):
          if (line[0]==' '):
              if xflag:
                examples=examples+pad
              else:
                examples=examples+'\n'+pad
              xflag=True
          else :
            if xflag:
              # returning from indented block, add extra linebreak
              examples=examples+'\n'
              xflag=False
          examples = examples+pad+line+'\n'
      examples = examples.decode('utf-8')+'\n\n'
    else:
      print("WARNING: {} has no examples!".format(c.split()[0]))
      examples = u''

    #process the rest of details section.
    q= re.compile(u'Details:\n(.+?)$',re.DOTALL)
    x = re.search( q, htext)
    if x:
      match=htext[x.start()+9:].split('\n')
      htext=htext[:x.start()] # truncate the bit we matched
      details=pad+'\n   **Details:**\n\n'
      section=u''
      iflag=False
      for line in match:
        if (line !=''):
          if (line[0]==' '):
             line= pad+pad+line
             iflag=True
          elif iflag:
             line= '\n'+pad+line
             iflag=False
          if ((len(line)<70) & ((line[-1:]=='.') | (line[-1:]==':'))):
             line=line+'\n'
          section = section+'\n'+pad + line.decode('utf8','ignore')
      details= details+section+'\n\n'
    else:
      print("**SEVERE WARNING**: {} has no DETAILS!".format(c.split()[0]))
      details=''
    
    # generate options

    q= re.compile(u'\nOptions:\n(.+?)$',re.DOTALL)
    x = re.search( q, htext)
    if x:
      match=htext[x.start()+10:].split('\n')
      htext=htext[:x.start()] # truncate the bit we matched
      options=pad+'**Options:**\n\n'
      for line in match:
        if (line !=''):
          if (line[0]=='-'):
             options = options+pad+"_"+line.strip()+"_\n\n"
          else:
             options = options+pad+line.strip()+"\n\n"
      options = options.decode('utf-8')
    else:
      print("**SEVERE WARNING**: {} has no Options!".format(c.split()[0]))
      options=''

    # get usage and summary
    q= re.compile(u'Usage:(.+?)\n\nSummary:\n(.+?)$',re.DOTALL)
    x = re.search( q, htext)    
    usage=pad+"**Usage:** `"+x.groups()[0].decode('utf-8')+"`\n\n"
    summary=pad+"**Summary:**\n\n"+pad+x.groups()[1].decode('utf-8')+"\n\n"
    outfile.write(header+usage+summary+options+details+examples+also+alias+'\n \n\n')


outfile.close()
