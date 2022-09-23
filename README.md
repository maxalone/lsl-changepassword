# lsl-changepassword

script to allow the password change of the avatar directly in-world OpenSimulator

the script must be inserted in an object with touch event enabled.
it asks for the password and a repeat for confirmation.
the data is BASE64 encrypted with an XOR operation and a random key and sent with a POST via https to the url and port of the container / service where the OpenSimulator administration XMLRPC server has been configured if enabled (for standalone config /OpenSim.ini [RemoteAdmin])

in my case I use a NODEJS endpoint made with RED lowcode of which I attach the source in the separate folder but feel free to create a server-side endpoint in any language

the code is provided as it is for transparency operations and useful for taking ideas or inspiration
