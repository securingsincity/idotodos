/* setup.js */

const jsdom = require('jsdom').jsdom;

global.document = jsdom('');
global.window = document.defaultView;
global.window.titanUrl = 'http://localhost';
Object.keys(document.defaultView).forEach((property) => {
  if (typeof global[property] === 'undefined') {
    global[property] = document.defaultView[property];
  }
});

global.navigator = {
  userAgent: 'node.js'
};
