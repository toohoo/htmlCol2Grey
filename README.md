# htmlCol2Grey
A simple Perl script for changing color in HTML-files or CSS-files to grey-values by its 
RGB-proportions

**Annotation**
This is not really a project rather than a little helper. 

## Idea

The core idea of this script is in the calculation of a grey color value by taking the average of 
the RGB-portion ( _red/green/blue_ ) of the color and spreading this value over the 3 color portions. 
The brightness should remain in this task. 

## Run

Call `[perl] [./]htmlCol2Grey.pl` on command line/shell.

The help message states:
```
htmlCol2Grey - Th. Hofmann, Apr 2018 -  turn all #RRGGBB codes to grey values
usage: [perl] [./]htmlCol2Grey.pl [-o] (file-name)
  -o = overwrite existing out file
```
