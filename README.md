# Mathematical Model of Mitochondrial Bioenergetics Function

## Created by: Chris Cadonic

Created for submission in the M. Sc. project in the Biomedical Engineering program at the University of Manitoba

### Files

This repository houses all of the code necessary for running my masters project in MATLAB. The code housed here
was initially developed in MATLAB R2014a and then further developed in MATLAB R2015a. 

Some of the important files for running this model are: **main.m**, **setup.m**, and **FerretSetup.m**. Main.m 
starts the program by first generating all of the parameters and relevant model information by calling setup.m. 
Next the program is displayed by passing in the *parameters* structure to **finalgui.m**, which controls the 
display of the GUI and the functionality of all of the GUI components.

To edit the system parameters, many of these edits can be carried out directly in the GUI. For more information on
editing within the GUI, see the section below on [*The Components of the GUI*](#the-components-of-the-gui). Parameter values, initial values, 
and data sources are all directly modifiable in the GUI. For changing default values in any aspect of the model,
however, they must be edited at the time of creation of the *parameters* structure, found in the setup.m function.

### Running the Model

As detailed above, the model can be run simply by navigating to the location of **main.m** and then running this 
function. The model will be initialized and the GUI will be promptly displayed. Before any simulation is run, the
parameters and initial conditions are set to default values. To change these before simulation, they can be directly
edited in the text boxes that accompany the value desired. To run a simulation of mitochondrial bioenergetics 
function, hit the *Plot* button in the bottom section of the GUI. This will solve the model using ode45 or ode23t
in MATLAB, and then plot the resulting quantities for all four sections of the graph.

### The Components of The GUI

![GUI Image](/Images/guiImageSep2.png)

In this figure, the GUI layout is shown, including axes and all input areas. 
With respect to input areas, the top three sections control:
* Initial Conditions
	* The user can vary the input to each of the listed initial concentrations
	* There is a *randomize* button for generating a random set of initial conditions
		* Pressing the **R** key will trigger the randomize button
	* There is a *default* button for resetting the initial conditions to default values
			* Pressing the **E** key will trigger the reset initial conditions button
* Parameter Values for a Control Condition of the Model
	* Currently unused
* Parameter Values for an Experimental Condition of the Model
	* The user can edit each parameter value directly, which will update the model values
	* There is also a *default* reset button found in the bottom-left section labeled *Optimization*
		* Pressing the **D** key will trigger the reset parameters button

	
Next, the botttom three sections control:
* Optimization
	* This button is for running **launchQubist.m**, which will run Jason Fiege's *Ferrret* genetic algorithm
	for the purpose of optimizing the parameters to fit given data.
		* Pressing the **O** key will trigger the optimization button
	* The *load params* button allows the user to search for a *-BestResults.mat* file, which is automatically
	generated by *Ferret* using the post-processing script **analyzeResults.m**. These files are housed within the
	/DeterministicModel/Solutions/ directory.
		* Pressing the **L** key will trigger the load parameters function
	* There is a *default* button found here, as detailed above, for resetting the parameter values in the experimental
	condition
		* Pressing the **D** key will trigger the reset parameters button
* Data Source Control
	* Here there are three buttons for indicating where data will be imported from, allowing the user to decide
	whether the model will try to emulate Seahorse XF data, Oroboros Oxygraph data, or from a matlab .mat file
* Plotting
	* The user can click the large *Plot* button to instruct the program to solve the model, and then display the 
	resulting behavior of the system in the axes found to the right of the control panels.
		* Pressing the **P** key will trigger the plot function
	
The axes illustrate the behavior of the system one *Plot* is clicked. As shown below, once it is selected, the system
then graphs and labels each axis to display what the model is simulating with regard to mitochondrial function.

![GUI with graphs](/Images/guiGraphsSep2.png)

### Additional Functions of the GUI

Several additional functions were introduced into the GUI of the program, each of which will be discussed in detail in
this section.

#### Right-Clicking a Graph

![Right-click graphs](/Images/guiRightClickSep2.png)

Each graph, once plotted, can then be right-clicked for additional options. These options allow for the user to either
save a blown-up image of the plot to a PNG file, or for opening the image in a new figure window for inspection and
editing purposes. Both options facilitate creating large images of the graphs for presentation or publication.

![Open right-clicked graph in a new figure window](/Images/guiOpenGraphSep2.png)

Opening the graph in another figure window enables editing and formatting using the figure MATLAB functionality. 
Labeling can be controlled using the figure menus built-in to MATLAB, and the figure can be exported into any format
after editing is finalized. Zooming in and out of the graph can also be done in this figure window.

#### Save Snapshot

![Save a snapshot of the GUI](/Images/guiSaveSnapshotSep2.png)

In the *File* menu, there is an option for saving a snapshot of the GUI. The purpose of this is to save the current display
of the GUI either for presentation or publication, where the graphs of each element of the system are shown along
with the set of parameters and initial conditions that were used to acquire this behavior. Default location for saved images
are in the **StateImages** directory.

The keyboard hotkey for this function is **ctrl+d** on windows and linux systems (with windows keyboard layout, 
not EMACS) and **cmd+d** on MAC OS X systems.

#### Save/Load Session

![Save or load sessions](/Images/guiSaveSessionSep2.png)

In addition to being able to save a snapshot of the GUI as an image to be viewed or presented later, the state of the 
model can also be saved. The save and load session commands are found in the *File* menu, with shortcuts 
**ctrl+s** for saving a session and **ctrl+o** for opening.

Saving a session allows the user to save the current values of all variables and all graphics objects in the guidata and
handles structures, which will default to save as a .mat. Once this .mat is saved, it can later be reloaded using the load
command giving the user the chance to re-open the state of the chosen file. Saved sessions are generally stored in the
**Savestates** directory. *Make sure to only load session .mat files*.

#### Help Commands

![Check the current version of the model](/Images/guiHelpCommandsSep2.png)

In the *Help* menu, there is a *Version* button and an *Info...* button. The Version button allows the user
to confer with the Git system to check the current tagged version of the program. This will inform the user whether
or not there are any available updates to the model or the GUI code so that the most up-to-date version of the simulation
model can be accessible to the user without complication. The *Info...* button will pull up this README.md document
in the appropriate default program.