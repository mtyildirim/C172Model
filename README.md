# C172Model
Dynamic model and sensor fusion for Cessna 172 , autopilot is still in development.

This model was created for "Hardware And Software Architecture In Autonomous Vehicles" and "Navigation Algorithms And Calculations" courses at Marmara University Institute of Pure and Applied Sciences, by Muhammet Tarık Yıldırım at January 2023. Aim of the project was to develop a model and an autopilot based on GPS positions to fly the model on the shortest path between waypoints.

### Simulation Prerequisites;

1 - MATLAB/SIMULINK

2 - FlightGear

### To run the simulation ; 

1 - Download all files to the same directory

2 - Open runfg.bat

3 - Open cessa_model.slx

4 - Run the SIMULINK model

## General Information

### The Main Model

Model was developed using Stability Coefficients. At "Simulation Model" subsystem you can view the main dynamic model and enviorment models.The states in the main model are the Velocities on body, Angular Rates, Euler Angles, position of the vehicle on Flat Earth Coordinate Frame and the Velocities on Earth Frame. Inıtial conditions are zero for all states except position and the starting position is Runway 06 at Sabiha Gökçen Airport. Waypoints are determined to take the Cessna from Sabiha Gökçen Airport and land it on Atatürk Airport.

### Engine Model

Engine model was developed using SIMULINK block from the Aerospace Blockset.It is designed to keep the model at the cruising speed ( which is 60 m/s ). When the model reaches cruising speed the engine increases and decreases thrust as neccessary to keep the model at cruising speed.

### Navigation Computer

Sensor models and relevant sensor fusion are modelled with SIMULINK blocks and used written functions. At the "Navigation Computer" subsystem you will see three subsystems named "IMU", "GPS" and "Position,Velocity and Orientation Sensor Fusion". Sensor noises are neglected to prevent simulation from running too slow.

##### IMU 

IMU was modelled using SIMULINK IMU block, it accepts accelerations on body,angular rates, angular accelerations, center of gravity of the vehicle and the gravity as inputs and returns accelerometer and gyroscope data. To prevent accelerometer measuring the gravity, the acceleration outputs are summed with gravity. Also a "Complimentary Filter" was used to measure orientation data.

##### GPS 

GPS reciever was modelled with SIMULINK GPS block and uses discrete position and velocity data from the main model. Block returns position in Latitude,Longtitude and Altitude, Velocities , Groundspeed and Course as outputs.

##### Position,Velocity and Orientation Sensor Fusion

In this subsystem calculations for the position of the vehicle, velocity of the vehicle and the orientation of the vehicle are modelled. At first you will see three subsystems and a discrete integrator in this subsystem, the discrete integrator is applied to the acceleration data from the IMU to create a velocity data. In sub-subsystems we will use discrete time integrator again to calculate the position on Flat Earth Frame by applying the integrator to velocity data.The three sub-subystems are "Velocity Fusion" for calculating the velocity data, "Position Fusion" to calculate the position data and the "Orientaiton" to calculate orientation data.

###### Position Fusion

By applying discrete time integrator to velocity data we have created  a position data on Flat Earth Frame and convert it to LLA. Then we fuse this data with the GPS block's LLA data with a Kalman Filter. By subtracting two datas we create the measurement error matrix for the Kalman Filter and the process error matrix will be from Velocity Fusion" sub-subsystem.Also I have used a pressure sensor to calculate the altitude because its more accurate than GPS and IMU based altitude calculations.

###### Velocity Fusion 

By using the 3 vector velocity formula and the velocity data from the GPS, we can implement a sensor fusion with a Kalman Filter.By subtracting two datas we will have the process error matrix for our Kalman Filters.

###### Orientation

In this sub-subsystem we have two ways to calculate the model's orientation. First is to use gyroscope data and calculate the orientation with Quaternions and the other one is the "Complimentary Filter". From experiment I have concluded that Quaternions are more accurate so I used Quaternions.

### Flight Computer

There is a single sub-subsystem in this subsystem and it tries to generate a trajectory from waypoints and generate control surface commands for the dynamic model ie. the autopilot. I haven't been able to successfully develop a system to accomplish this, so this sub-subsystem is still in development.



