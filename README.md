
# Device registry

A project created as recruitment task for Housecall Pro.

## Description
Project contains Ruby on rails application that manages device assingment registry. There are 2 main entities: Users and Devices

## Author
- [Adrian Jobda](https://www.github.com/theConsite)


## Requirements and TODO
Requirement | Done 
--- | --- 
User can assign the device only to themself. | &check;
User can't assign the device already assigned to another user. | &check;
Only the user who assigned the  device can return it. | &check;
If the user returned the device in the past, they can't ever re-assign the same device to themself. | &check;
Successful execution of commands in order:  1.Setting up the proper Ruby version. 2.Running bundle install. 3.Running rspec spec. 4. Running rake db:test:prepare. | &check;

TODO | Done
---|---
Clone this repo to your local machine| &check;
Fix the config, so you can run the test suite properly| &check;
Implement the code to make the tests pass for AssignDeviceToUser service| &check;
Following the product requirements listed above, implement tests for returning the device and then implement the code to make them pass| &check;
In case you are missing additional product requirements, use your best judgment. Have fun with it| &check;