coffee --output . -bc src/*.coffee 
coffee --output ./lib -bc src/lib/*.coffee 
coffee --output ./layouts -bc src/layouts/*.coffee
coffee --output ./config -bc src/config/*.coffee
# cp config/config-sample.js ~/.twm/twm.js
nohup gnome-shell --replace > log &
