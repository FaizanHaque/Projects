globals [
  percent-similar
  percent-other
  percent-unhappy
  percent-uncontent ;;what percent of the turtles are uncontent with the diversity?

  total-resources
  topright-resources
  topleft-resources
  bottomright-resources
  bottomleft-resources

  total-number
  topright-number
  topleft-number
  bottomright-number
  bottomleft-number

  total-average
  topright-average
  topleft-average
  bottomright-average
  bottomleft-average


  temp-resources
  temp-cost

]

patches-own [
  cost              ;; the minimum amount of "resources" a turtle msut have to live in this patch
                    ;; a turtle can live in any patch as long as it fits the minimum
]

turtles-own [
 happy?
 content?          ;; similar to happy? above, except instead of asking for %-similar-wanted,
                   ;; it indicates whether the turtle has, among its neighbours, at least a certain %
                   ;; of other colored turtles
 resources         ;; an overall indicator of how much resources the turtle has (money, education... etc)
 similar-nearby
 other-nearby
 total-nearby
  identifier ;; identifies what color the turtle is
]
to setup
  clear-all
  ;; create turtles on random patches.
  ask patches [
    if random 100 < density [   ;; set the occupancy density
      sprout 1 [
       set shape "triangle"
        ;;        set shape one-of ["circle" "triangle"]
        set color one-of [ red green ]
      ]
    ]
  ]
  ask patches [
    if pxcor > 0  and pycor > 0 ;; patches on the top right corner
      [ set cost 90 ]
    if pxcor > 0 and pycor < 0 ;; patches on the bottom right corner
    [ set cost 30 ]
    if pxcor < 0 and pycor > 0 ;;patches on the top left  corner
    [set cost 60]
    if pxcor < 0 and pycor < 0 ;; patches on the bottom left corner
    [ set cost 0 ]
    ;;  set cost random 100
  ]

  ask turtles [
    set resources random 100
  ;;  if resources > 50 [set shape "circle" ];;color red]
  ;; if resources < 50 [set  shape "square" ] ;;color green]
  ;;  if resources = 50 [set shape "triangle" ]
    if color = red [ set identifier "red" ]
    if color = green [ set identifier "green"]

    if resources-matter
    [
;;    if color = red [ set identifier "red" ]
  ;;  if color = green [ set identifier "green"]

    ;;if color = red [ set color scale-color red resources 0 100]
    ;;if color = green [ set color scale-color green resources 0 100]
      if pxcor = 0 [ set cost 999]

      if pycor = 0 [ set cost 999] ;; do not allow turtles to move to the boundaries
    ]
  ]


  update-turtles
  update-globals

  reset-ticks

  if mode = "diversity" [
  ]
  if mode = "segregation" [
  ]


end
to go
  if mode ="segregation"
  [
    if all? turtles [ happy? ] [ stop ]
    move-unhappy-turtles
  ]
  if mode = "diversity"
  [
    if all? turtles [ content? ] [ stop ]
    move-uncontent-turtles
  ]
  update-turtles
  update-globals
  tick

end


;; unhappy turtles try a new spot
to move-unhappy-turtles
  ask turtles with [ not happy? ]
    [ find-new-spot ]
end

;; uncontent turtles try a new spot
to move-uncontent-turtles
  ask turtles with [ not content? ]
    [ find-new-spot ]
end



;; move until we find an unoccupied spot
to find-new-spot
  ;;set temp-resources resources of turtles-here
  ;;set temp-cost cost of patch-here
  rt random-float 360
  fd random-float 10

;;  if color of patch-here blue [ find-new-spot] ;; don't allow the turtles to live on the boundaries


  if any? other turtles-here [ find-new-spot ] ;; keep going until we find an unoccupied patch]
;;  if not any? turtles-here[
  ifelse resources-matter
  [;; if resources < cost of patch-here[ find-new-spot]

    if any? other turtles-here [ find-new-spot ] ;; keep going until we find an unoccupied patch]
    if resources > cost ;;of patch-here
      [  move-to patch-here  ;; move to center of patch
  ] ]
  [ move-to patch-here]
  ;;  ]
end




to update-turtles
  ask turtles [
    ;; in next two lines, we use "neighbors" to test the eight patches
    ;; surrounding the current patch

    ;;if color = "green"
    ;;;[
     ;; set similar-nearby count (turtles-on neighbors)  with [ color = "green" ]
    ;;  set other-nearby count (turtles-on neighbors) with [ color = "red" ]
  ;;    set total-nearby similar-nearby + other-nearby
;;    ]

   ;; if color = "red"
  ;;  [
;;      set similar-nearby count (turtles-on neighbors)  with [ color = "red" ]
     ;; set other-nearby count (turtles-on neighbors) with [ color = "green" ]
    ;;  set total-nearby similar-nearby + other-nearby
   ;; ]

   ;; set similar-nearby count (turtles-on neighbors)  with [ color = [ color ] of myself ]
   ;; set other-nearby count (turtles-on neighbors) with [ color != [ color ] of myself ]
    set similar-nearby count (turtles-on neighbors)  with [ identifier = [ identifier ] of myself ]
   set other-nearby count (turtles-on neighbors) with [ identifier != [ identifier ] of myself ]
    set total-nearby similar-nearby + other-nearby
    if mode ="segregation"
    [
      set happy? similar-nearby >= (%-neighbours-wanted * total-nearby / 100)
    ]
    if mode ="diversity"
    [
      set content? other-nearby >= (%-neighbours-wanted * total-nearby / 100)
    ]


    if show-resources? ;; show how much resources a turtle has
 [
   if resources-matter
      [
      if color = red [ set color scale-color red resources 0 100]
      if color = green [ set color scale-color green resources 0 100]
      if pxcor = 0 [ set pcolor blue set cost 999]
      if pycor = 0 [ set pcolor blue set cost 999] ;; do not allow turtles to move to the boundaries
    ]
    ]

    ;;   [ set label resources ] ;; the label is set to the value of the turtle's resources
   ;; [ set label "" ] ;; the label is set to an empty text value

    ;    if xcor > 0  and ycor > 0 ;; turtles on the top right corner
 ;     [set topright-number topright-number + 1
 ;       set topright-resources topright-resources + [resources] of myself ]
 ;   if xcor > 0 and ycor < 0 ;; patches on the bottom right corner
  ;  [ set bottomright-number bottomright-number + 1
  ;      set bottomright-resources bottomright-resources + [resources] of myself  ]
  ;  if xcor < 0 and ycor > 0 ;;patches on the top left  corner
  ;  [set topleft-number topleft-number + 1
  ;      set topleft-resources topleft-resources + [resources] of myself ]
  ;  if xcor < 0 and ycor < 0 ;; patches on the bottom left corner
   ; [ set bottomleft-number bottomleft-number + 1
    ;    set bottomleft-resources bottomleft-resources + [resources] of myself ]


  ]
end

to update-globals
  let other-neighbors sum [other-nearby] of turtles
  let similar-neighbors sum [ similar-nearby ] of turtles
  let total-neighbors sum [ total-nearby ] of turtles
  set percent-similar (similar-neighbors / total-neighbors) * 100
  set percent-other (other-neighbors / total-neighbors ) * 100
  if mode = "segregation"
  [
  set percent-unhappy (count turtles with [ not happy? ]) / (count turtles) * 100
  ]
    if mode = "diversity" [
  set percent-uncontent (count turtles with [ not content? ]) / (count turtles) * 100
  ]
    set percent-other (other-neighbors / total-neighbors) * 100

    set topright-number count (turtles) with [xcor > 0  and ycor > 0]
    set bottomright-number count (turtles) with [xcor > 0  and ycor < 0]
    set topleft-number count (turtles) with [xcor < 0  and ycor > 0]
    set bottomleft-number count (turtles) with [xcor < 0  and ycor < 0]
    set total-number count (turtles)

  if resources-matter [
    set total-resources sum [resources ] of turtles
    set topright-resources  sum [resources ] of turtles with [xcor > 0  and ycor > 0]
    set bottomright-resources sum [resources ] of turtles with [xcor > 0  and ycor < 0]
    set topleft-resources sum [resources ] of turtles with [xcor < 0  and ycor > 0]
    set bottomleft-resources sum [resources ] of turtles with [xcor < 0  and ycor < 0]

    set total-average ( total-resources / total-number )
    set topright-average (topright-resources / topright-number)
    set topleft-average (topleft-resources / topleft-number)
    set bottomright-average (bottomright-resources / bottomright-number)
    set bottomleft-average (bottomleft-resources / bottomleft-number)

  ]


end

to hide-resources
  ask turtles
  [
    if color = red [set color red]
    if color = green [set color green]
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
751
552
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
0
0
1
ticks
1000.0

SLIDER
3
16
175
49
density
density
50
99
78.0
1
1
%
HORIZONTAL

CHOOSER
3
49
141
94
mode
mode
"segregation" "diversity"
1

SLIDER
2
103
176
136
%-neighbours-wanted
%-neighbours-wanted
0
100
47.0
1
1
NIL
HORIZONTAL

TEXTBOX
8
142
183
175
Segregation: Similar neighbours wanted\nDiversity: Other neighbours wanted
9
0.0
1

BUTTON
4
178
67
211
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
4
248
153
281
show-resources?
show-resources?
1
1
-1000

BUTTON
66
178
135
211
go (once)
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
135
178
198
211
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
4
215
153
248
resources-matter
resources-matter
0
1
-1000

MONITOR
752
10
837
55
NIL
percent-similar
17
1
11

MONITOR
842
10
932
55
NIL
percent-other
17
1
11

TEXTBOX
90
365
240
421
cost:\n60|90\n--+--\n00|30\n
11
0.0
1

MONITOR
1103
58
1211
103
NIL
topright-number
17
1
11

MONITOR
1004
59
1105
104
NIL
topleft-number
17
1
11

MONITOR
863
60
982
105
NIL
topright-resources
17
1
11

MONITOR
751
60
864
105
NIL
topleft-resources
17
1
11

MONITOR
1004
102
1105
147
NIL
bottomleft-number
17
1
11

MONITOR
1104
102
1211
147
NIL
bottomright-number
17
1
11

MONITOR
863
104
982
149
NIL
bottomright-resources
17
1
11

MONITOR
751
104
863
149
NIL
bottomleft-resources
17
1
11

MONITOR
1004
146
1211
191
NIL
total-number
17
1
11

MONITOR
752
149
982
194
NIL
total-resources
17
1
11

MONITOR
774
226
886
271
NIL
topleft-average
17
1
11

MONITOR
886
227
991
272
NIL
topright-average
17
1
11

MONITOR
774
271
885
316
NIL
bottomright-average
17
1
11

MONITOR
885
271
991
316
NIL
bottomleft-average
17
1
11

MONITOR
774
316
991
361
NIL
total-average
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

This is an extension to the segregation (schelling) model. There are two extensions, the first is accessible by selecting "diversity" in the mode drop down menu and the second is by switching on "resources-matter." The "diversity" extension considers the idea that just as some people have an inclination towards living among people of their own group, there are also others (especially in the twentyfirst century) who actively want to live and work in a diverse community.
The "resources matter" extension considers the fact that moving to a new location generally has a cost which requires resources (which includes money, network, education, vehicles among many other things).

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

Resources:

Upon setup each turtle is also allocated (randomly) a resource count from 1-100. 

Patches on the bottom-left corner cost 0 (i.e are accesible by all turtles). 
Patches on the bottom-right corner cost 30 (are only accessible to turtles with resources > 30)    
Patches on the top-left corner cost 60 (are only accessible to turtles with resources> 60)    
Patches on the top-right corner cost 90 (are only accessible to turtles with resources> 90)  


The 
patches to the left have no cost, wheras the patches on the right have a cost of 50 resources ( i.e a turtle with more than 50 resources can move to any patch but a turtle with less than 50 resources is limited to moving only to the left side of the region).




## HOW TO USE IT


Press SETUP to clear the screen, create a new set of turtles and assign each of them a color and a "resources" count. The resources variable will only be application in the "Resources Matter" mode.


Diversity mode:

The "mode" chooser should be at "segregation" as default, select "diversity" from the "mode" chooser, leave "resources-matter" and "show-resources" switched off and ignore the "spatial-division" chooser.

Vary "density" and "%-neighbour-wanted." Density refers to the fraction (in %) of the patches that will have a turtle upon setup. The "%-neighbour-wanted" is analogous to the "%-similar-wanted" in the original model and serves the same purpose in the "segregation" mode, but in the "diversity" mode it tells the model the % of neighbours that need to be different from the turtle instead of similar.

Resources Matter mode:

Switch on "resources-matter." Hit run and ideally the turtles should only go to the patches they can afford. (I haven't been able to get rid of the over lapping turtles, so it may be hard to notice).
If you switch on "show-resources" you can see the amount of resources each turtle has (it goes lightest shade = least amount of resrouces to darkest shade = most amount of resources), except for the turtles with the least amount of resources.





## THINGS TO NOTICE

In the diversity mode there is a  range around 50% "5-other-wanted" where the turtles of different colors start gathering in alternating lines.

On the right side there are various monitors that display %-similar and %-other updates, the number of turtles in one of the four regions and the toal number of turtles. If you turn on "resources-matter" you can also see the collective resource amount in the four regions as well as the total amount of resources all the turtles have. Similarly the averages display the respective sum of resources divided by number of turtles in that region.

See how chaning the density and the "%-other-wanted" for the diversity mode can lead to stable and unstable circumstances. 

Compare non-resource mode to resource mode with the same initial conditions

## THINGS TO TRY

Play around with the "%-neighbour-wanted" and the "density"

## EXTENDING THE MODEL


## RELATED MODELS

Segregation model

## CREDITS AND REFERENCES



Schelling, T. (1978). Micromotives and Macrobehavior. New York: Norton.

Rauch, J. (2002). Seeing Around Corners; The Atlantic Monthly; April 2002;Volume 289, No. 4; 35-48. http://www.theatlantic.com/magazine/archive/2002/04/seeing-around-corners/302471/

Wilensky, U. (1997). NetLogo Segregation model. http://ccl.northwestern.edu/netlogo/models/Segregation. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
