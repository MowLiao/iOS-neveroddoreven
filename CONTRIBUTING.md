-- First time set up  

* Set up git:
* `git setup --global user.name "firstname secondname"`
* `git setup --global user.email useremail@domain.ac.uk`
* `ssh-keygen -t rsa -C "your.email@example.com" -b 4096`
* Navigate to your `.ssh/id_rsa.pub` and copy and paste into https://gitlab.com/profile/keys
* Find the directory you want to store the project and `git pull git@gitlab.com:comp3222/18/ferret.git`