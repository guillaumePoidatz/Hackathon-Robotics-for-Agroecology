# Hackathon-Robotics-for-Agroecology
This a project for the Hackathon Robotics for Agroecology. The topic is : Obstacle detection and recognition. All informations can be found here : https://firahackathon.github.io/?fbclid=IwAR14gKIbOR2scjgifEMRdKmUK_fKvjAmKbxGcg4kViKbL_qvVRHuGqjvwck#

The goal is to build an algorith that will :
- give the number of obstacles
- and their position

The algorithm will be evaluated on :
- Percentage of successful detection,
- Number and position of objects/pedestrians,
- Average time detection.

The deliverables are :
- a code either in the form of source code to be compiled or in the form of an executable evaluated using criteria,
- a presentation of the solution to a panel of experts.

The environment will be emulated by two different simulator depending on the stage of the hackathon :
- First stage is on gazebo with constant grip conditions, flat ground and smooth slopes, with limited dynamics,
- Second stage is on 4D|Virtualiz with different grip conditions, uncertain ground and slopes, and a more realistic dynamic.
All the environment and sensors are provided on ros2/Gazebo 

The focus will be on the blue square below :
<img width="732" alt="Capture d’écran 2023-12-16 à 20 45 02" src="https://github.com/guillaumePoidatz/Hackathon-Robotics-for-Agroecology/assets/79081686/8839070d-bce7-416d-afe7-6f6c4af8a398">

The mobile robot into gazebo is the adap2e robot below. It is a mobile robot with 4 drive and steering wheels. The available sensors are :
- GPS,
- IMU (inertial measurement unit for the acceleration and the angular velocity),
- Lidar,
- Camera,
- Stereo camera,
- RGBD.

<img width="579" alt="Capture d’écran 2023-12-16 à 20 49 37" src="https://github.com/guillaumePoidatz/Hackathon-Robotics-for-Agroecology/assets/79081686/2fcfe5c7-dcdd-48e4-b600-4243d5d1ba8a">

This environment is fixed and will not be modifiable during the hackathon.

For the topic concerning "obstacle detection and recognition", or more precisely : "pedestrian detection in the field", the pedestrian is replaced :
- in stage 1 by an object in ISO 18497 (pedestrian replaced by cylinder, one big for the body and a smaller one for the head) in static,
- in stage 2 by a numeric pedestrian who can move.

Hackathon organisation provides :
- Algorithm to follow path,
- GPS trajectory.

The goal as said before is to provide detection solutions which gives object/pedestrian positions or areas. 

Maybe the areas can be better than the areas if for example the pedestrian is moving (better information than position that won't be good anymore in the future).

The evaluation criteria are : 
- Clarity of the explanation,
- New Method,
- Originality of the method used.

The first deadline (first stage) to propose the algorithm is the 10th of january.

To know how to use the ressources availables : fira_hackathon_workspace
