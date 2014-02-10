coffee --output . -bc src/*.coffee 
coffee --output ./api -bc src/api/*.coffee 
coffee --output ./layouts -bc src/layouts/*.coffee
cp config-sample.js ~/.twm/twm.js
