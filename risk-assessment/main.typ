
#show heading.where(level: 1): it => { underline(smallcaps(text(size: 16pt, it))) }
#show heading: it => {it}

#show table.cell.where(y: 0): it => {text(weight: "bold", it)}
#show table.cell.where(y: 1): it => {text(weight: "bold", it)}

#let entry(likelihood_before, consequences_before, likelihood_after, consequences_after, hazard, risks, mitigations) = [
  #let score_before = likelihood_before * consequences_before
  #let score_after = likelihood_after * consequences_after

  #box(outset: (left: -10pt) )[= #hazard]
  
  == Risks & Potential Consequences
  #risks

  == Mitigations & Control Measures
  #mitigations

  #block(breakable: false, table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    
    table.cell(colspan: 3, [Before Mitigations]),
    table.cell(colspan: 3, [After Mitigations]),
    table.header([Likelihood], [Severity], [Score], [Likelihood], [Severity], [Score],),
    [#likelihood_before], [#consequences_before], [#score_before], [#likelihood_after],  [#consequences_after],  [#score_after], 
  ))
  
]

#text(size: 22pt)[Design Special Topic 5: Project D Risk Assessment \ #datetime.today().display("[day] [month repr:long] [year]")]

In every case, team members will ensure that they are kept abreast of appropriate first-aid information, such as the location of the nearest first-aider and first-aid kit. Near misses will be reported to the appropriate persons.  

#text(size: 20pt)[Rankine Lab 605]
#entry(3, 4, 1, 2)[
  Poor Housekeeping
][
  Personal effects may cause trip hazards if allowed to accumulate, and spilt liquids could cause slip hazards.  
][
  Jackets and bags will either be left on coathangers or stored under tables, and no open containers of liquids will be brought into the lab, per the lab rules. 
]

#entry(3, 2, 2, 1)[
  Eye and Muscle Strain
][
  The project will involve significant amounts of computer use. This may cause eye, back, and wrist strain if undertaken for long periods of time. 
][
  Users of computers will take small, frequent breaks, stretch regularly, and take "micro-breaks", where the individual focuses on a distant object for a few seconds. 
]

#entry(1, 5, 1, 3)[
  Electric Shock 
][
  While high voltage equipment will not be directly used, work will be carried out in a lab that contains such equipment.
][
  The lab is equipped with appropriate RCD devices, and care will be taken not to work near high-voltage equipment if not necessary or handle liquids near such equipment. 
]

#entry(2, 5, 1, 3)[
  Fire
][
  As with all use of electronics, there is a small risk of fire. Fires in the lab may also be started by other users of the lab besides the team members.  
][
  The lab is fitted with appropriate smoke alarms and firefighting equipment. Electronic equipment will be turned off when not in use.  
]





#pagebreak()
#text(size: 20pt)[Rankine Lab 210]
#entry(3, 5, 1, 1)[
  Class 3B (5mW) Laser
][
  A class 3B laser with a power output of 5mw will be used. This is sufficient to cause rentinal burns and permanent eye damage.

  As the laser will be incident on a steel razor blade and fixed to a steel surface, a significant amount of laser light could be reflected in an unpredictable manner. 
][
  All team members will participate in a laser safety course. All team members will wear appropriate protective eyewear. The lab that will be used will be equipped with a laser interlock, so that the door to the lab cannot be opened while the laser is in operation. 
]

#entry(3, 4, 1, 2)[
  Loud Noise
][
  The organ pipe generates a loud noise. The level has not been measured, but from preliminary demonstrations it is loud enough to cause discomfort.
][
  All team members will ensure that hearing protection of at least 20dB attenuation is worn before the pipe is operated. 
]

#entry(3, 4, 1, 2)[
  Poor Housekeeping
][
  The lab has limited floor area and little space between the optics tables and the walls. If the area is not kept tidy, trip and slip hazards could quickly accumulate. Minor to significant injuries could occur from falling against the optics bench and equipment. 
][
  Floors will be kept clear at all times, and more thorough checks will be undertaken after entering and before leaving the lab to ensure there are no potential trip hazards.
]



#entry(3, 2, 2, 1)[
  Eye and Back Strain
][
  The project will involve significant amounts of computer use, and use of small devices on the optics bench. These both may cause eye and back strain if undertaken for long periods of time. 
][
  Users of computers and the optics bench will take small, frequent breaks, stretch regularly, and take "micro-breaks", where the individual focuses on a distant object for a few seconds. 
]

#entry(3, 2, 2, 2)[
  Sharps and Cut Hazards
][
  The project will involve the use of a razor blade as an optical stop. Careless handling of this may cause minor to moderate cuts.  
][
  Care will be taken when handling the blade. When the blade is not in use it will be covered to reduce the likelihood of accidentally touching the edge. Brightly-coloured tape will be affixed to the razor to make it more visible. 
]

#entry(1, 5, 1, 3)[
  Electric Shock 
][
  While high voltage equipment will not be directly used, work will be carried out in a lab that contains such equipment.
][
  The lab is equipped with appropriate RCD devices, and care will be taken not to work near high-voltage equipment if not necessary or handle liquids near such equipment. 
]

#entry(2, 5, 1, 3)[
  Fire
][
  As with all use of electronics, there is a small risk of fire. Additionally, the laser may cause materials to burn if held in the beam at close range. 
][
  The lab is fitted with appropriate smoke alarms and firefighting equipment. Care will be taken to ensure that the laser is kept clear of objects that may uintentionally interrupt the beam. Electronic equipment will be turned off when not in use.  

  Fire safety information is kept in the lab. 
]






