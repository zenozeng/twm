coffee --output . -bc src/*.coffee 
coffee --output ./api -bc src/api/*.coffee 
coffee --output ./layouts -bc src/layouts/*.coffee
coffee --output ./config -bc src/config/*.coffee
cp config/config-sample.js ~/.twm/twm.js
