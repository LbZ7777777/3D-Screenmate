# 3D-Screenmate
3D Screenmate Video Game made in Godot Engine for ECE 1895 Junior Design

# Design Overview
The program intends to build an interesting desktop widget to alleviate boredom. Ideally, it would also have functional elements, such as an AI chatbot, desk-break timers, etc. Unfortunately, the current state of this project is barebones due to time constraints.

Originally, the design was to include significant personality in the screenmates, as well as a complex environment for interactions.
![image](https://github.com/user-attachments/assets/68139be8-ebb7-4fbe-8c33-11ad433fa7d9)
Instead, the final project managed to accomplish the most barebones of requirements to qualify as a screenmate program, and even those barebone requirements are achieved at a sketchy level.

Given my inability to achieve the desired vision within a time frame somewhat diminished by procrastinated and underestimated senior design and junior design Bop-it projects, a full six week development period would likely have been more fleshed out but still unable to fully accomplish my initial objectives.

# Preliminary Design Verification
## Multiple Windows
The screenmate program was developed in parts. First, early portions of a tutorial on using multiple windows in Godot was trialed.
[geegaz-multiple-windows-tutorial.zip](https://github.com/user-attachments/files/20025941/geegaz-multiple-windows-tutorial.zip)
Unfortunately, my decision to temporize full testing of the multiple windows system, especially with regards to my initially 3D workspace, meant this section's early design verification failed to catch the litany of issues I would later have with the windows.

## Animation
After the multiple windows tutorial, I attempted to follow an outdated tutorial on animating a Skeleton3D Godot node:
https://docs.godotengine.org/en/3.0/tutorials/3d/working_with_3d_skeletons.html
Because I went in-depth into this tutorial and ultimately converted it directly into the final Screenmate program, I did encounter bugs. In fact, whenever I thought I had finished the preliminary design verification for animations, as I proceeded to begin integration I would discover another error.

The most frustrating animation bugs I encountered were:
* the tutorial using global bone rotation transforms when it should have used local bone rotation transforms
* struggling with Godot's input map b/c I didn't realize I forgot to adjust the function that actually executes a transform
* not knowing when I had to manually call constructors, hence causing springbones to work improperly and for an extra, non-functional copy of the character model to be instantiated
* not realizing my self-made interpolation equation would return a bad value when multiplying infinity by 0, and thereby causing bones transformed by the undefined values to completely vanish

Most of the relevant Godot scenes for the animation system's development are still cluttering the GitHub.

## Other
Because the animation system consumed so much of my time, I never prototyped the system for moving sprites around the user's desktop, and I certainly never prototyped the systems I did not have a chance to implement.

# Design Implementation
The final system only contains three main components:
![image](https://github.com/user-attachments/assets/9dfb6d53-07a4-4ced-a00f-d0fb3b69d9c7)
These are the backbone of the intended screenmate program design, as they most heavily leverage the Godot game engine's features.

My implementation philosophy was to find a relevant tutorial which looked legible--targeted towards individuals of my low expertise level--and to simply follow that tutorial until I encountered a bug. Then, I would do Google research for ways to tackle the bug. If I failed to find a bug fix that worked, I might revamp my design structure entirely. For instance, when attempting to let my sprites be dragged by mice, I initially attempted to use Area2D nodes but simply could not get the collision signals to work. As such, I resorted to a low level solution of essentially making my own Area2D functions. But those actually didn't work properly either until I worked my way through some other bugs!
