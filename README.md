# A Masterless Puppet Solution 
One way of using Puppet is without a Puppet master, otherwise known as "masterless Puppet".  There are pros and cons to this as described below:

PROS
- Less complicated infrastructure
- No certs to worry about
- We can still use R10K and environments per branch for separation  

CONS
- No orchestration
- No reporting out of the box

The main reason I like this approach is because when you start going down the immutable server route you only need to worry about configuring the server once.  
You don't really need the overhead of managing a Puppet master and the state management.
 
